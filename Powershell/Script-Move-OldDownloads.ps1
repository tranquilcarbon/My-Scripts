<#
.SYNOPSIS
    This script lists all Active Directory (AD) computers, including their operating system and last logon date.

.DESCRIPTION
    The script retrieves all computers from Active Directory and displays their name, operating system, and last logon date.
    It uses the `Get-ADComputer` cmdlet, which requires the Remote Server Administration Tools (RSAT) to be installed.
    If RSAT is not installed, the script catches the error and provides instructions on how to install RSAT.

.EXAMPLE
    PS> .\ListADComputers.ps1
    Active Directory Computers:
    Name            OperatingSystem            LastLogonDate
    ----            ----------------            -------------
    PC1             Windows 10 Pro              2023-09-25
    SERVER01        Windows Server 2019         2023-09-24
    
    Finished script at '2024-09-25 12:34:56Z'. Took '00:00:05.1234567' to run.

.DETAILS
    The script will attempt to retrieve AD computers with the `Get-ADComputer` cmdlet. If an error occurs, likely due to 
    missing RSAT, the script outputs a helpful message with a link to install RSAT for Windows 11.

.Output
    Table: Outputs a table of Active Directory computer details, including Name, Operating System, and Last Logon Date.

.LINK
    https://techcommunity.microsoft.com/t5/windows-11/how-to-install-or-uninstall-rsat-in-windows-11/m-p/3273590

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

# Get the list of files older than $DaysOld
$OldFiles = Get-ChildItem -Path $SourceDir -Recurse |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$DaysOld) }

# Check if any files match the criteria
if ($OldFiles.Count -eq 0) {
    Write-Host "No files found older than $DaysOld days."
} else {
    # List the files that will be moved
    Write-Host "The following files are older than $DaysOld days and will be moved to the archive folder:`n"
    $OldFiles | Select-Object FullName, LastWriteTime | Format-Table -AutoSize

    # Ask for confirmation
    $Confirmation = Read-Host "Do you want to move these files? (Y/N)"

    if ($Confirmation -eq "Y") {
        # Move the files
        $OldFiles | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $ArchiveDir -Force
        }
        Write-Host "Files have been successfully moved."
    } else {
        Write-Host "File move operation cancelled."
    }
}