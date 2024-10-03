<#
.SYNOPSIS
    Compress files in a specified directory into a 7-Zip archive using the 7-Zip command-line tool.

.DESCRIPTION
    This script allows the user to specify a folder for compression. It lists the files in the specified folder and then prompts for confirmation to proceed with compressing the files into a .7z archive. 
    The user is asked to provide a name for the archive and a destination location where the archive will be saved. 
    The script uses the 7-Zip command-line tool to perform the compression.

.EXAMPLE
    PS> .\CompressFilesWith7Zip.ps1
    Please enter folder location: C:\Documents
    Folder contains:
    FullName                           LastAccessTime        
    --------                           -------------        
    C:\Documents\File1.txt             2023-09-21 10:15:00
    C:\Documents\Folder\File2.jpg      2023-09-22 11:00:00

    OK to proceed? (Y/N): Y
    Please enter archive name (For example, Mars-Trip-2028.7z): ArchiveName.7z
    Please enter location to store archive at (For example, C:\archives): C:\BackupArchives
    Files have been successfully compressed.

.DETAILS
    - This script uses the 7-Zip command-line tool to compress files.
    - The user is prompted to provide the source folder, archive name, and destination location.
    - If no files are found in the specified folder, the script exits.
    - Compression is executed using the 7-Zip executable located at the default path.

.OUTPUT
    String: Displays file paths that will be compressed and outputs the result of the compression operation.

.LINK
    N/A

.AUTHOR
    tranquilcarbon
    Date: 25/09/2024
#>


# Critical Variables

$7zLocation = "C:\Program Files\7-Zip\7z.exe" # Windows default location

# Show debug info
Write-Host = "7Zip CLI location:" $7zLocation

# Ask user where to compress
$SourceDir = Read-Host "Please enter folder location"
Write-Host "Folder contains:"
# List the files that will be compressed
$ActingFiles | Select-Object FullName, LastAccessTime | Format-Table -AutoSize

$ActingFiles = Get-ChildItem -Path $SourceDir -Recurse

# Check if any files match the criteria
if ($ActingFiles.Count -eq 0) {
    Write-Host "No files found."
} else {


    # Ask for confirmation
    $Confirmation = Read-Host "OK to proceed? (Y/N)"


    if ($Confirmation -eq "Y") {
    # Ask user for archive name:
    $ArchiveName = Read-Host "Please enter archive name (For example, Mars-Trip-2028.7z)"
    $ArchiveLocation = Read-Host "Please enter location to store archive at (For example, c:\archives)"
        & $7zLocation a $ArchiveLocation\$ArchiveName $SourceDir
        Write-Host "Files have been successfully compressed."
    } else {
        Write-Host "File operation cancelled."
    }
}