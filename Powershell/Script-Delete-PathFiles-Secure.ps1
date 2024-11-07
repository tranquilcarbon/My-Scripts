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
# Define the path to sdelete.exe (change this if you've moved it)
$sdeletePath = "C:\Programs\sdelete.exe"

# Function to securely delete files using sdelete
function SecurelyDelete-Files {
    param (
        [string]$FolderPath
    )

    # Check if the folder exists
    if (-Not (Test-Path -Path $FolderPath -PathType Container)) {
        Write-Host "Error: The folder '$FolderPath' does not exist." -ForegroundColor Red
        return
    }

    # Get a list of files in the directory
    $files = Get-ChildItem -Path $FolderPath -File

    if ($files.Count -eq 0) {
        Write-Host "No files found in the specified folder." -ForegroundColor Yellow
        return
    }

    # Display the list of files to be deleted
    Write-Host "Files to be deleted:" -ForegroundColor Green
    foreach ($file in $files) {
        Write-Host $file.FullName -ForegroundColor Cyan
    }

    # Prompt for confirmation before proceeding
    $confirmation = Read-Host "Are you sure you want to delete these files? (y/n)"
    if ($confirmation.ToLower() -ne 'y') {
        Write-Host "Operation cancelled by user." -ForegroundColor Yellow
        return
    }

    # Loop through each file and securely delete it using sdelete
    foreach ($file in $files) {
        $filePath = $file.FullName
        try {
            & $sdeletePath -f $filePath
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Successfully deleted: $filePath" -ForegroundColor Green
            } else {
                Write-Host "Failed to delete: $filePath. Error code: $LASTEXITCODE" -ForegroundColor Red
            }
        } catch {
            Write-Host "Error deleting file: $filePath. $_" -ForegroundColor Red
        }
    }

    Write-Host "Deletion process completed." -ForegroundColor Green
}

# Main script execution
$FolderPath = Read-Host "Enter the path of the folder containing files to delete"
SecurelyDelete-Files -FolderPath $FolderPath
