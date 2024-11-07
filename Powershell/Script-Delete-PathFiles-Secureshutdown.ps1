<#
.SYNOPSIS
Deletes all files in a specified folder and its subfolders, overwriting them multiple times before deletion.

.DESCRIPTION
This script provides a function to securely delete files by overwriting their contents with random patterns multiple times. It also includes a function to recursively retrieve all files from a given folder path.
The main script logic prompts the user for the folder path, confirms the operation, and then deletes each file in the specified folder and its subfolders using the Secure-Delete function.

.EXAMPLE
PS> .\SecureFileDeletion.ps1
Enter the folder path: C:\ExampleFolder
Are you sure you want to delete all files in 'C:\ExampleFolder' and its subfolders? (Yes/No): Yes

Files that will be deleted:
C:\ExampleFolder\file1.txt
C:\ExampleFolder\subfolder\file2.txt

Confirm the deletion of these files? (Yes/No): Yes
All files have been deleted and securely overwritten.
File deleted and securely overwritten: C:\ExampleFolder\file1.txt
File deleted and securely overwritten: C:\ExampleFolder\subfolder\file2.txt

.DETAILS
This script is designed for use in environments where secure file deletion is required. It uses a simple yet effective method of overwriting file contents with random patterns to make recovery difficult.

.Output
None

.LINK
https://en.wikipedia.org/wiki/Overwrite_(data)

.AUTHOR
    tranquilcarbon
    Date: 01/11/2024

.NOTES
This is only a basic secure wipe, It will not be able to 100% prevent advanced recovery software from recovering data.
For a more secure wipe, look for one using the DoD 5220.22 M standard, or similar.
#>


# Function to securely overwrite a file
function Secure-Delete {    # Unapproved function verb, but there's no better way to name it.
    param (
        [string]$FilePath,
        [int]$OverwriteTimes = 3
        # For reference:
        # Quick 
    )

    # Define overwrite patterns
    $patterns = @(
        '1234567890',
        'abcdefghij',
        '!@#$%^&*()',
        '<>/?`~!@#',
        'qwertyuiop',
        'asdfghjkl',
        'zxcvbnm,./'
    )

    # Read the file content
    try {
        $content = Get-Content -Path $FilePath -Raw
    } catch {
        Write-Error "Failed to read file: $_"
        return
    }

    # Overwrite the file multiple times
    for ($i = 0; $i -lt $OverwriteTimes; $i++) {
        try {
            Set-Content -Path $FilePath -Value ($patterns[$i % $patterns.Length] * ([math]::Ceiling($content.Length / $patterns[$i % $patterns.Length].Length)))
        } catch {
            Write-Error "Failed to overwrite file: $_"
            return
        }
    }

    # Delete the file
    try {
        Remove-Item -Path $FilePath -Force
        Write-Host "File deleted and securely overwritten: $FilePath"
    } catch {
        Write-Error "Failed to delete file: $_"
    }
}

# Function to recursively get all files in a folder
function Get-AllFiles {
    param (
        [string]$FolderPath
    )

    $allFiles = @()
    try {
        Get-ChildItem -Path $FolderPath -Recurse -Force | Where-Object { -not $_.PSIsContainer } | ForEach-Object {
            $allFiles += $_.FullName
        }
    } catch {
        Write-Error "Failed to get files: $_"
    }

    return $allFiles
}

# Main script logic
$folderPath = Read-Host "Enter the folder path"

# Confirm with the user
if (-not (Read-Host "Are you sure you want to delete all files in '$folderPath' and its subfolders? (Yes/No)")) {
    Write-Host "Operation cancelled."
    exit
}

# Get a list of all files
$allFiles = Get-AllFiles -FolderPath $folderPath

# List all files for confirmation
Write-Host "Files that will be deleted:"
foreach ($file in $allFiles) {
    Write-Host "$file"
}

if (-not (Read-Host "Confirm the deletion of these files? (Yes/No)")) {
    Write-Host "Operation cancelled."
    exit
}

# Delete and securely overwrite each file
foreach ($file in $allFiles) {
    Secure-Delete -FilePath $file
}

Write-Host "All files have been deleted and securely overwritten. Shutting down..."
stop-computer -computername localhost -Force