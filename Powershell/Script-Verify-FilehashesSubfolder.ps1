# Prompt the user for the directory path
$directoryPath = Read-Host -Prompt "Enter the full path of the directory containing files and hash files"

# Check if the path exists
if (!(Test-Path -Path $directoryPath)) {
    Write-Host "The directory does not exist. Exiting..." -ForegroundColor Yellow
    exit
}

# Define hash algorithms and file extensions
$hashTypes = @{
    "MD5"    = ".md5"
    "SHA1"   = ".sha1"
    "SHA256" = ".sha256"
    "SHA512" = ".sha512"
}

# Prompt user to choose the hash type or to check all
$selectedHashType = Read-Host -Prompt "Enter the hash type to verify (MD5, SHA1, SHA256, SHA512) or 'ALL' to check all"

# Validate the selected hash type
if ($selectedHashType.ToUpper() -ne "ALL" -and -not $hashTypes.ContainsKey($selectedHashType.ToUpper())) {
    Write-Host "Invalid hash type selected. Exiting..." -ForegroundColor Yellow
    exit
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

# Recursively process files in a directory and its subdirectories
function Process-Directory {
    param (
        [string]$path
    )
    
    # Get a list of files excluding hash files
    $filesToCheck = Get-ChildItem -Path $path -File | Where-Object {
        $_.Extension -notin $hashTypes.Values
    }

    foreach ($file in $filesToCheck) {
        # Determine which hash types to verify based on user input
        $hashesToCheck = if ($selectedHashType.ToUpper() -eq "ALL") {
            $hashTypes.Keys  # Check all hash types
        } else {
            @($selectedHashType.ToUpper())  # Check only the selected hash type
        }

        foreach ($hashType in $hashesToCheck) {
            # Construct the expected hash file path
            $hashFilePath = Join-Path -Path $path -ChildPath ($file.BaseName + $hashTypes[$hashType])

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

    # Recursively process subdirectories
    Get-ChildItem -Path $path -Directory | ForEach-Object {
        Process-Directory -path $_.FullName
    }
}

# Start processing from the user-specified directory
Process-Directory -path $directoryPath
