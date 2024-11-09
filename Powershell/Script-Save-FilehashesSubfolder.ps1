<#
.SYNOPSIS
Calculates and saves hash values for all files in a specified directory using multiple hashing algorithms.

.DESCRIPTION
This script prompts the user to enter the full path of a directory. It then checks if the provided path exists. If it does, the script calculates hash values for each file in the directory using a set of predefined hashing algorithms (MD5, SHA1, SHA256, and SHA512). The hashes are saved to corresponding files with specific extensions (e.g., .md5, .sha1).

The main script logic includes:
1. Prompting the user for the directory path.
2. Checking if the directory exists.
3. Iterating through each file in the directory.
4. Calculating hash values using specified algorithms.
5. Saving the hash values to files with appropriate extensions.

.EXAMPLE
PS> .\FileHashCalculator.ps1
Enter the full path of the directory: C:\ExampleFolder

Hash for file.txt using MD5 saved to C:\ExampleFolder\file.txt.md5
Hash for file.txt using SHA1 saved to C:\ExampleFolder\file.txt.sha1
Hash for file.txt using SHA256 saved to C:\ExampleFolder\file.txt.sha256
Hash for file.txt using SHA512 saved to C:\ExampleFolder\file.txt.sha512

.DETAILS
This script is useful for verifying the integrity of files by generating hash values. Hashing helps in detecting unauthorized modifications or corruption.

.Output
None

.LINK
https://en.wikipedia.org/wiki/Hash_function

.AUTHOR
    tranquilcarbon
    Date: 08/11/24
#>

# Prompt the user for the directory path
$directoryPath = Read-Host -Prompt "Enter the full path of the directory"

# Check if the path exists
if (!(Test-Path -Path $directoryPath)) {
    Write-Host "The directory does not exist. Exiting..." -ForegroundColor Red
    exit
}

# Define a function to calculate hashes
function Get-FileHashWithAlgorithm {
    param (
        [string]$filePath,
        [string]$algorithm
    )
    # Calculate the hash using the specified algorithm
    $hashResult = Get-FileHash -Path $filePath -Algorithm $algorithm
    return $hashResult.Hash
}

# List of hash algorithms and file extensions (excluding CRC32)
$hashTypes = @{
    "MD5"    = ".md5"
    "SHA1"   = ".sha1"
    "SHA256" = ".sha256"
    "SHA512" = ".sha512"
}

# List of ignored file extensions
# Will not be hashed.
$ignoredExtensions = @(".md5", ".sha1", ".sha256", ".sha512")

# Process each file in the directory and its subdirectories
foreach ($file in Get-ChildItem -Path $directoryPath -File -Recurse) {
    # Check if the file extension is not in the list of ignored extensions
    if ($ignoredExtensions -notcontains $file.Extension.ToLower()) {
        $allHashFilesExist = $true

        foreach ($hashType in $hashTypes.Keys) {
            $hashFilePath = Join-Path -Path $file.DirectoryName -ChildPath ($file.BaseName + $hashTypes[$hashType])
            if (!(Test-Path -Path $hashFilePath)) {
                $allHashFilesExist = $false
                break
            }
        }

        if ($allHashFilesExist) {
            Write-Host "$($file.Name) already has all hashes. Skipping..." -ForegroundColor Yellow
        } else {
            foreach ($hashType in $hashTypes.Keys) {
                # Generate the hash
                $hash = Get-FileHashWithAlgorithm -filePath $file.FullName -algorithm $hashType

                # Save the hash to a file with the appropriate extension
                $hashFilePath = Join-Path -Path $file.DirectoryName -ChildPath ($file.BaseName + $hashTypes[$hashType])
                $hash | Out-File -FilePath $hashFilePath -Encoding UTF8

                Write-Host "File hash created."  -ForegroundColor Green
                Write-host "File name: $($file.Name)"  -ForegroundColor Green
                Write-Host "Hash name: $($hashFilePath)"  -ForegroundColor Green
                Write-Host "Hash type: $($hashType)"  -ForegroundColor Green
                Write-Host "Hash: $($hash)"  -ForegroundColor Green
            }
        }
    } else {
        Write-Host "$($file.Name) ignored because it already has a hash file extension." -ForegroundColor Yellow
    }
}
