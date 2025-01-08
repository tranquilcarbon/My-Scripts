# Function to convert images in a folder from one format to another
function Convert-ImageFormat {
    param (
        [string]$inputFolder = ".",
        [string]$outputFormat = "jpg"
    )

    # Check if ImageMagick is installed and available in PATH
    $magickPath = Get-Command magick -ErrorAction SilentlyContinue
    if ($null -eq $magickPath) {
        Write-Host "ImageMagick is not installed or not added to PATH. Please install ImageMagick and ensure 'magick' is accessible."
        return
    }

    # Check if input folder exists
    if (-Not (Test-Path -Path $inputFolder)) {
        Write-Host "Input folder '$inputFolder' does not exist."
        return
    }

    # Get all image files in the input folder
    $imageExtensions = @("jpg", "png", "bmp", "gif", "tif")
    $filter = "*." + ($imageExtensions -join ",*.")
    $imageFiles = Get-ChildItem -Path $inputFolder -Filter $filter

    if ($imageFiles.Count -eq 0) {
        Write-Host "No image files found in '$inputFolder' with extensions: $($imageExtensions -join ', ')"
        return
    }

    # Convert each image to the specified format
    foreach ($file in $imageFiles) {
        $outputFile = Join-Path -Path $inputFolder -ChildPath ([System.IO.Path]::ChangeExtension($file.Name, $outputFormat))
        magick $file.FullName $outputFile
        Write-Host "Converted '$($file.FullName)' to '$outputFile'"
    }

    Write-Host "Conversion complete!"
}

# Main script execution
function Main {
    # Prompt user for input folder
    $inputFolder = Read-Host "Enter the path of the folder containing images (press Enter for current directory)"

    # If user pressed Enter, use the current directory
    if ([string]::IsNullOrWhiteSpace($inputFolder)) {
        $inputFolder = "."
    }

    # Prompt user to select output format
    $outputFormat = Read-Host "Enter the desired output image format (e.g., jpg, png)"

    # Convert images
    Convert-ImageFormat -inputFolder $inputFolder -outputFormat $outputFormat
}

# Run the main script
Main
