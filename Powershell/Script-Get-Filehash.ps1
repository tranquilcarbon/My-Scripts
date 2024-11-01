<#
.SYNOPSIS
    This script asks the user for a file path and a file, then displays all hashes

.DESCRIPTION
    The script identifies files in the user's Downloads folder that have not been modified in a specified number of days (default is 30 days).
    It preserves the directory structure when moving files to an Archive subfolder within the Downloads directory.
    The script provides a list of the files to be moved and prompts the user for confirmation before proceeding.

.EXAMPLE
    PS> .\MoveOldFiles.ps1
    Source Path: C:\Users\Username\Downloads
    Archive Path: C:\Users\Username\Downloads\Archive
    The following files are older than 30 days and will be moved to the specified archive directory.

    FullName                            LastAccessTime         
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
    Date: 25/09/2024
#>

# Function to calculate CRC32 hash
function Get-CRC32 {
    param (
        [string]$FilePath
    )

    $crc32 = new-object System.Security.Cryptography.Crc32
    $buffer = [System.IO.File]::ReadAllBytes($FilePath)
    $crc32.ComputeHash($buffer) | ForEach-Object { $_.ToString("X2") }
}

# Function to calculate MD5 hash
function Get-MD5 {
    param (
        [string]$FilePath
    )

    $md5 = new-object System.Security.Cryptography.MD5CryptoServiceProvider
    $buffer = [System.IO.File]::ReadAllBytes($FilePath)
    $md5.ComputeHash($buffer) | ForEach-Object { $_.ToString("X2") }
}

# Function to calculate SHA-1 hash
function Get-SHA1 {
    param (
        [string]$FilePath
    )

    $sha1 = new-object System.Security.Cryptography.SHA1Managed
    $buffer = [System.IO.File]::ReadAllBytes($FilePath)
    $sha1.ComputeHash($buffer) | ForEach-Object { $_.ToString("X2") }
}

# Function to calculate SHA-256 hash
function Get-SHA256 {
    param (
        [string]$FilePath
    )

    $sha256 = new-object System.Security.Cryptography.SHA256Managed
    $buffer = [System.IO.File]::ReadAllBytes($FilePath)
    $sha256.ComputeHash($buffer) | ForEach-Object { $_.ToString("X2") }
}

# Function to calculate SHA-512 hash
function Get-SHA512 {
    param (
        [string]$FilePath
    )

    $sha512 = new-object System.Security.Cryptography.SHA512Managed
    $buffer = [System.IO.File]::ReadAllBytes($FilePath)
    $sha512.ComputeHash($buffer) | ForEach-Object { $_.ToString("X2") }
}

# Main script logic
try {
    # Prompt user for folder path
    $folderPath = Read-Host "Enter the full path of the folder containing the file"

    # Check if the folder exists
    if (-Not (Test-Path $folderPath)) {
        Write-Error "The specified folder does not exist."
        exit
    }

    # Prompt user for file name
    $fileName = Read-Host "Enter the name of the file to hash"

    # Construct full file path
    $filePath = Join-Path -Path $folderPath -ChildPath $fileName

    # Check if the file exists
    if (-Not (Test-Path $filePath)) {
        Write-Error "The specified file does not exist in the folder."
        exit
    }

    # Display hash values
    Write-Host "CRC32 (Insecure): $(Get-CRC32 -FilePath $filePath)"
    Write-Host "MD5 (Insecure): $(Get-MD5 -FilePath $filePath)"
    Write-Host "SHA-1 (Insecure): $(Get-SHA1 -FilePath $filePath)"
    Write-Host "SHA-256: $(Get-SHA256 -FilePath $filePath)"
    Write-Host "SHA-512: $(Get-SHA512 -FilePath $filePath)"

} catch {
    Write-Error $_.Exception.Message
}
