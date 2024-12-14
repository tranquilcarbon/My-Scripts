# Specify the 7z executable path
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"

# Preset variables
$Corecount = $env:NUMBER_OF_PROCESSORS  # Get amount of cores
$7zParameters = "-bt -mx=9 -mmt=$corecount" # Defines parameters to run 7zip to

# The line below solves a weird problem where 7zip would refuse to work with
# Parameters that exceed one or more.
$7z_arguments = @($7zParameters.split(' '))

#===Program===
Write-Host "============DEBUG============"
Write-Host "7zip location: $sevenZipPath"
Write-Host "7zip parameters: $7zParameters"
Write-Host "Core Count $Corecount"
$7zFolderpath = Read-Host "Enter folder path to compress name (e.g., e:\temp.7z)"
$outputFileName = Read-Host "Enter output file name (e.g., archive.7z)"

# Compress the files and subfolders at maximum compression
& $sevenZipPath a @7z_arguments "$outputFileName" "$7zFolderpath"
