# Prompt the user for the directory path
$directoryPath = Read-Host -Prompt "Enter the full path of the directory containing files and hash files"

# Check if the path exists
if (!(Test-Path -Path $directoryPath)) {
    Write-Host "The directory does not exist. Exiting..."
    exit
}

# Define hash algorithms and file extensions
$hashTypes = @{
    "MD5"    = ".md5"
    "SHA1"   = ".sha1"
    "SHA256" = ".sha256"
    "SHA512" = ".sha512"
}

# Function to calculate hash for a file using a specified algorithm
function Get-FileHashWithAlgorithm {
    param (
        [string]$filePath,
        [string]$algorithm
    )
    # Calculate the hash using the specified algorithm
    $hashResult = Get-FileHash -Path $filePath -Algorithm $algorithm
    return $hashResult.Hash
}

# Get a list of files excluding hash files
$filesToCheck = Get-ChildItem -Path $directoryPath -File | Where-Object {
    $_.Extension -notin $hashTypes.Values
}

# Verify each file's hash
foreach ($file in $filesToCheck) {
    foreach ($hashType in $hashTypes.Keys) {
        # Construct the expected hash file path
        $hashFilePath = Join-Path -Path $directoryPath -ChildPath ($file.BaseName + $hashTypes[$hashType])

        # Check if the hash file exists
        if (Test-Path -Path $hashFilePath) {
            # Read the stored hash from the hash file
            $storedHash = Get-Content -Path $hashFilePath -Raw | Out-String
            $storedHash = $storedHash.Trim()  # Remove any trailing newline or whitespace

            # Calculate the current hash for the file
            $calculatedHash = Get-FileHashWithAlgorithm -filePath $file.FullName -algorithm $hashType

            # Compare the calculated hash with the stored hash
            if ($calculatedHash -eq $storedHash) {
                Write-Host "[$hashType] Hash for $($file.Name) is VALID." -ForegroundColor Green
            } else {
                Write-Host "[$hashType] Hash for $($file.Name) is INVALID." -ForegroundColor Red
                Write-Host "File hash was: [$storedHash]" -ForegroundColor Red
                Write-Host "Real hash was: [$CalculatedHash]" -ForegroundColor Red
                Write-Host "File potentially corrupt or has been tampered with." -ForegroundColor Red
            }
        } else {
            Write-Host "No $hashType hash file found for $($file.Name)" -ForegroundColor Yellow
        }
    }
}
