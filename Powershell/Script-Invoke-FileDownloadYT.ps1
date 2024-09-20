<#.SYNOPSIS
  Downloads a video from a provided URL in either video or audio format.
.DESCRIPTION
  This script will use YT-DLP (Or a variant of) to download a video from a 
  provided URL. It is capable of downloading from many websites, a full list
  can be found here:
  https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  URL - Web address of video to download (For example, https://www.youtube.com/watch?v=dQw4w9WgXcQ)
  Download type: What should the download be formatted as? (Audio or Video)
  Format - What should the video be downloaded in? (MP4, MP3, FLAC, ETC.)
  Location - Where should the file be downloaded? (C:\Downloads)
.OUTPUTS
  Video stored at URL in a desired format (For example, MP4 or MP3)
.NOTES
  Version:        1.0
  Author:         FCT
  Creation Date:  19/08/24
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

#Variables
$YT_DL_Location = "C:\Programs\yt-dlp.exe" #Location to YT-DL

Write-Host "Now select your format to download to:"
Write-Host "==============================Video================================"
Write-Host "A) MP4 - Highly compatible, Good compression, High power, Lossy"
Write-Host "B) WEBM - Small filesize, Open Format, Lower Compatibility"
Write-Host "C) MKV - Higher quality, Open Format, Bigger Filesize, Less compatible"
Write-Host "==============================Audio================================"
Write-Host "D) MP3 - Highly compatible, Good compression, Lossy"
Write-Host "E) AAC - Less compatible, Better compression than MP3, better sounding than MP3"
Write-Host "F) FLAC - Less compatible, Good compression, High quality audio"
Write-Host "G) WAV - Large filesize, High Quality, high compatibility"