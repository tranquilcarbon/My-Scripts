<#
.SYNOPSIS
    This script downloads a file from a specified URL to the user's desktop.

.DESCRIPTION
    The script prompts the user for a download URL and confirms whether to proceed with the download. 
    It determines the file destination (the user's desktop), retrieves the filename, and proceeds with the download using `Invoke-WebRequest`. 
    The script logs the start and end times, and calculates the total elapsed time for the operation.

.EXAMPLE
    PS> .\DownloadFile.ps1
    Please enter a download path: https://example.com/file.zip
    Do you want to continue? (Y/N): Y
    Download URI is: https://example.com/file.zip
    Download Location is: C:\Users\User\Desktop
    File Download complete.
    Finished script at '2024-09-20 14:45:12Z'. Took '00:01:20' to run.

.DETAILS
    This script allows users to download files from a URL to their desktop with confirmation prompts. 
    It provides feedback to the user about the start time, destination, and end time of the download.

.Output
    String: Outputs the download path, confirmation prompts, and completion messages.

.LINK
    N/A

.AUTHOR
    tranquilcarbon
    Date: 20/09/2024
#>


begin {
    # Display the time that this script started running.
    [DateTime] $startTime = Get-Date
    Write-Information "Starting script at '$($startTime.ToString('u'))'."
  
    # Main part of script
  # Source URL
$url = Read-Host "Please enter a download path: "

# Destation file
$dest = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)

# Display to user
Write-Host "Download URI is: $url"
Write-Host "Download Location is: $dest"

# Prompt to begin

$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -eq 'y') {
	# Get the filename, because Powershell can't extract it in one operation.
	Function Get-RedirectedUrl {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )

    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()

    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}
	# Begin Downloading if input is Y
	Clear-Host
	Invoke-Webrequest -Uri $url -OutFile $(Split-Path -Path $url -Leaf)
	Write-Host "File Download complete."
}


  }

  end{
    [DateTime] $finishTime = Get-Date
    [TimeSpan] $elapsedTime = $finishTime - $startTime
    write-host "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run."
    }
