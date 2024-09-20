<#
.SYNOPSIS
    This script renames files in a specified folder by replacing the original file name with its SHA256 hash.

.DESCRIPTION
    The script prompts the user to enter a folder path and checks if the specified path exists. 
    It recursively calculates the SHA256 hash for each file in the folder and its subfolders, 
    then renames each file using its hash value while retaining the original file extension.
    If any errors occur during the renaming process, they are logged to the console.

.EXAMPLE
    PS> .\RenameFilesWithHash.ps1
    Enter the folder path: C:\Users\User\Documents
    Renamed 'C:\Users\User\Documents\example.txt' to 'd7a8fbb307d7809469ca9abac5a7d0b540982a2db6e2fe6ce0bbf852cd104bb4.txt'
    Renamed 'C:\Users\User\Documents\image.png' to '3a4f03bfc1d5f0a7b4c3e1cbeb8d5f2d90b25f0d4de1e0e7f8db6e9c8b635a56.png'
    File renaming process completed.

.DETAILS
    This script utilizes the .NET cryptography library to compute SHA256 hashes for files. 
    It ensures that the original file extension is preserved when renaming. 
    The script gracefully handles errors that may arise during the renaming process.

.Output
    String: Outputs messages indicating the renaming status of each file processed.

.LINK
    N/A

.AUTHOR
    Your Name
#>


# Prompt the user to enter a folder path
$folderPath = Read-Host -Prompt "Enter the folder path"

# Check if the path exists
if (-Not (Test-Path $folderPath)) {
    Write-Host "The specified folder path does not exist. Please check the path and try again."
    exit
}

# Function to calculate SHA256 hash of a file
function Get-SHA256Hash {
    param (
        [string]$filePath
    )

    # Using PowerShell 7's `using` statement for the cryptography object
    # Opening a file stream with ReadOnly access
    try {
        $stream = [System.IO.File]::OpenRead($filePath)

        # Using a SHA256 hash object to compute the file's hash
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        $hashBytes = $sha256.ComputeHash($stream)

        # Convert the hash to a string, removing hyphens
        $hashString = [BitConverter]::ToString($hashBytes) -replace "-", ""
        return $hashString
    }
    finally {
        # Ensure that the file stream is closed properly
        $stream.Dispose()
    }
}

# Recursively get all files in the folder and subfolders
$files = Get-ChildItem -Path $folderPath -Recurse -File

foreach ($file in $files) {
    try {
        # Get the full file path
        $filePath = $file.FullName
        # Calculate the SHA256 hash of the file
        $hash = Get-SHA256Hash -filePath $filePath
        # Get the directory of the file
        $directory = $file.DirectoryName
        # Get the file extension
        $extension = $file.Extension
        # Construct the new file name with hash and original extension
        $newFileName = "$hash$extension"
        $newFilePath = Join-Path $directory $newFileName

        # Rename the file (works on both Windows and non-Windows environments)
        Rename-Item -Path $filePath -NewName $newFilePath -ErrorAction Stop
        Write-Host "Renamed '$filePath' to '$newFilePath'"
    }
    catch {
        Write-Host "Failed to rename file: $filePath. Error: $_"
    }
}

Write-Host "File renaming process completed."
