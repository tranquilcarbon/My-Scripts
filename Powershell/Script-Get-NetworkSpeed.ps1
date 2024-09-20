<#
.SYNOPSIS
    This script automates the process of listing speed test servers and performing a speed test using a selected server ID.

.DESCRIPTION
    The script interacts with the Speedtest CLI, allowing users to list available servers, select a server by its ID, and perform a speed test. 
    It logs the start and end times of the operation and provides instructions on selecting a server ID from a list or a URL. 
    The user is encouraged to perform multiple tests using different servers and average the results for best accuracy.

.EXAMPLE
    PS> .\SpeedtestAutomation.ps1
    Starting script at '2024-09-20 14:45:12Z'.
    Now listing servers...
    (Displays list of servers)
    ==============================================================================
    From the leftmost column, select a Server ID and type it, then press enter.
    Please enter a local server ID: 12345
    ==============================================================================
    Now beginning test using server #12345
    (Speed test results)
    Finished script at '2024-09-20 14:50:32Z'. Took '00:05:20' to run.

.DETAILS
    This script runs the Speedtest CLI located at "C:\Programs\Speedtest\Speedtest.exe". 
    It allows the user to select a server from the displayed list or via a global server URL. 
    After selection, it performs a speed test and outputs the results.

.Output
    String: Outputs server listing, speed test results, and elapsed time for the operation.

.LINK
    https://williamyaps.github.io/wlmjavascript/servercli.html
    List of servers
.AUTHOR
    tranquilcarbon
    Date: 20/09/2024
#>


begin {
    # Display the time that this script started running.
    # Program location
    [DateTime] $startTime = Get-Date
    Write-Information "Starting script at '$($startTime.ToString('u'))'."
  
    # Main part of script
    $SpeedtestLocation = "C:\Programs\Speedtest\Speedtest.exe"
    # Operation templates
    $ListServers = '--servers'
    Write-Host "Now listing servers..."
    & $SpeedtestLocation $ListServers
    
    Write-Host "=============================================================================="
    Write-Host "From the leftmost column, select a Server ID and type it, then press enter."
    Write-Host "You can also use the following URL For a list of servers globally."
    Write-Host "https://williamyaps.github.io/wlmjavascript/servercli.html"
    Write-Host "NOTE: For best results, repeat the test, each time using a different server"
    Write-Host "Then average the results."
    $DesiredServer = Read-Host "Please enter a local server ID "
    Write-Host "=============================================================================="
    Write-Host "Now beginning test using server #$DesiredServer"
    & $SpeedtestLocation --Server-id=$DesiredServer
  }
  
  end{
  [DateTime] $finishTime = Get-Date
  [TimeSpan] $elapsedTime = $finishTime - $startTime
  write-host "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run."
  }


