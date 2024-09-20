
Write-Host "================================Winget - Basic=================================="
Write-Host "Description: A script allowing for a computer to be quickly setup"
Write-Host "With applications most people will need."
Write-Host "==================================================================="
Write-Host "This script will install the following applications:"
Write-Host "7Zip - FOSS File Archival Tool"
Write-Host "Adobe Acrobat Reader (64 Bit) - Freeware PDF File reader"
Write-Host "The Document Foundation LibreOffice - FOSS office Suite"
Write-Host "Mozilla Firefox - FOSS Web Browser"
Write-Host "Notepad++ - FOSS text editor"
Write-Host "Paint.NET - Freeware Raster Graphics Editor"
Write-Host "ShareX - FOSS Screenshotting tool"
Write-Host "VLC Media Player - FOSS Media Player software"

Write-Host "This will take around 5 minutes to complete, and will consume around 800 MB - 1GB."

$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -eq 'y') {
	# Begin Installing.
    Clear-Host
    winget install --id 7zip.7zip
    winget install --id Adobe.Acrobat.Reader.64-bit
    winget install --id TheDocumentFoundation.LibreOffice
    winget install --id Mozilla.Firefox
    winget install --id Notepad++.Notepad++
    winget install --id dotPDN.PaintDotNet
    winget install --id ShareX.ShareX
    winget install --id VideoLAN.VLC
    write-host "Install complete."
}

