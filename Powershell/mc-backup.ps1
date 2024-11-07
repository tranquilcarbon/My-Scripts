

# Prompt user for MC Version location


# Does MC Version Location have a .\saves?


# Prompt user for location to save files to


# Get list of files to act on


# Create MD5 hashsum for verification against corruption, store in .\Hash


# Create SHA512 hashsum for verification against tampering, store in .\Hash


# 7zip archive files, save.
# Format DD-MM-YY-HH-MM-SS in ISO 8601 standard


# Create hash of 7zip archive, store alongside 7zip archive


###


# Prompt user for MC Version location
$mcVersionLocation = Read-Host "Please enter the path to your Minecraft version folder (e.g., C:\Minecraft\saves)"

# Check if the MC Version Location has a .\saves directory
$savesPath = Join-Path -Path $mcVersionLocation -ChildPath "saves"
if (-not (Test-Path -Path $savesPath)) {
    Write-Error "The specified path does not contain a 'saves' directory."
    exit 1
}

# Prompt user for location to save files to
$backupLocation = Read-Host "Please enter the path where you want to backup the saves (e.g., D:\MinecraftBackups)"

# Create MD5 hashsum for verification against corruption, store in .\Hash
$md5Path = Join-Path -Path $backupLocation -ChildPath "Hash"
if (-not (Test-Path -Path $md5Path)) {
    New-Item -ItemType Directory -Path $md5Path
}

# Create SHA512 hashsum for verification against tampering, store in .\Hash
$sha512Path = Join-Path -Path $backupLocation -ChildPath "Hash"
if (-not (Test-Path -Path $sha512Path)) {
    New-Item -ItemType Directory -Path $sha512Path
}

# Get list of files to act on
$filesToBackup = Get-ChildItem -Path $savesPath -Recurse

# 7zip archive files, save.
# Format DD-MM-YY-HH-MM-SS in ISO 8601 standard
$date = Get-Date -Format "dd-MM-yyyy-HH-mm-ss"
$archiveName = Join-Path -Path $backupLocation -ChildPath ("MinecraftBackup_$date.zip")

Compress-Archive -Path $filesToBackup.FullName -DestinationPath $archiveName

# Create hash of 7zip archive, store alongside 7zip archive
$md5Hash = (Get-FileHash -Path $archiveName -Algorithm MD5).Hash
$sha512Hash = (Get-FileHash -Path $archiveName -Algorithm SHA512).Hash

Set-Content -Path (Join-Path -Path $backupLocation -ChildPath "MD5_Hash.txt") -Value $md5Hash
Set-Content -Path (Join-Path -Path $backupLocation -ChildPath "SHA512_Hash.txt") -Value $sha512Hash

Write-Host "Backup completed successfully. Files are saved in '$archiveName'."
Write-Host "MD5 and SHA-512 hashes stored in 'Hash' directory."
