<#
.SYNOPSIS
    This script moves files older than a specified number of days from the Downloads folder to an Archive directory.

.DESCRIPTION
    The script identifies files in the user's Downloads folder that have not been modified in a specified number of days (default is 30 days).
    It preserves the directory structure when moving files to an Archive subfolder within the Downloads directory.
    The script provides a list of the files to be moved and prompts the user for confirmation before proceeding.

.EXAMPLE
    PS> .\MoveOldFiles.ps1
    Source Path: C:\Users\Username\Downloads
    Archive Path: C:\Users\Username\Downloads\Archive
    The following files are older than 30 days and will be moved to the specified archive directory.

    FullName                            LastWriteTime         
    --------                            -------------         
    C:\Users\Username\Downloads\File1.txt 2023-08-10 14:32:16
    C:\Users\Username\Downloads\Folder\File2.jpg 2023-08-01 11:45:12

    Do you want to move these files? (Y/N)

.DETAILS
    - The script uses a WinAPI call to retrieve the path to the Downloads folder.
    - It recursively checks all files and folders within the Downloads directory.
    - The destination is an "Archive" folder within the Downloads directory.
    - Folder structure is maintained during the move operation.
    - If no files older than the specified number of days are found, the script outputs a message and exits.

.Output
    String: Outputs the file paths of old files and confirms the move operation.

.LINK
    N/A

.AUTHOR
    tranquilcarbon
    Date: 2025/09/2024
#>

# Get the download folder location using WinAPI
function Get-DownloadFolderPath() {
    $SHGetKnownFolderPathSignature = @'
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    public extern static int SHGetKnownFolderPath(
        ref Guid folderId,
        uint flags,
        IntPtr token,
        out IntPtr lpszProfilePath);
'@

    $GetKnownFoldersType = Add-Type -MemberDefinition $SHGetKnownFolderPathSignature -Name 'GetKnownFolders' -Namespace 'SHGetKnownFolderPath' -Using "System.Text" -PassThru
    $folderNameptr = [intptr]::Zero
    [void]$GetKnownFoldersType::SHGetKnownFolderPath([Ref]"374DE290-123F-4565-9164-39C4925E467B", 0, 0, [ref]$folderNameptr)
    $folderName = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($folderNameptr)
    [System.Runtime.InteropServices.Marshal]::FreeCoTaskMem($folderNameptr)
    $folderName
}
# Variables
$SourceDir = Get-DownloadFolderPath
$ArchiveDir = "$(Get-DownloadFolderPath)\Archive"
$DaysOld = 30

# List Paths
write-host "Source Path: $SourceDir"
write-host "Archive Path: $ArchiveDir"
write-host "Please wait while files are analysed. This may a take a few minutes"
write-host "Depending on how many files are in your download directory."

# Get the list of files older than $DaysOld, excluding the ArchiveDir
$OldFiles = Get-ChildItem -Path $SourceDir -Recurse |
    Where-Object { 
        $_.LastWriteTime -lt (Get-Date).AddDays(-$DaysOld) -and
        $_.FullName -notlike "$ArchiveDir*"
    }

# Check if any files match the criteria
if ($OldFiles.Count -eq 0) {
    Write-Host "No files found older than $DaysOld days."
} else {
    # List the files that will be moved
    Write-Host "The following files are older than $DaysOld days and will be moved to the specified archive directory.`n"
    $OldFiles | Select-Object FullName, LastWriteTime | Format-Table -AutoSize

    # Ask for confirmation
    $Confirmation = Read-Host "Do you want to move these files? (Y/N)"

    if ($Confirmation -eq "Y") {
        foreach ($File in $OldFiles) {
            # Construct the destination path while maintaining folder structure
            $RelativePath = $File.FullName.Substring($SourceDir.Length)
            $DestinationPath = Join-Path $ArchiveDir $RelativePath

            # Ensure the destination folder exists
            $DestinationFolder = Split-Path $DestinationPath
            if (-not (Test-Path $DestinationFolder)) {
                New-Item -ItemType Directory -Path $DestinationFolder -Force | Out-Null
            }

            # Move the file to the destination, preserving folder structure
            Move-Item -Path $File.FullName -Destination $DestinationPath -Force
        }
        Write-Host "Files have been successfully moved."
    } else {
        Write-Host "File move operation cancelled."
    }
}