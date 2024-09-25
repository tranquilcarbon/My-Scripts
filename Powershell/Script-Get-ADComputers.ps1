<#
.SYNOPSIS
    This script lists all Active Directory (AD) computers, including their operating system and last logon date.

.DESCRIPTION
    The script retrieves all computers from Active Directory and displays their name, operating system, and last logon date.
    It uses the `Get-ADComputer` cmdlet, which requires the Remote Server Administration Tools (RSAT) to be installed.
    If RSAT is not installed, the script catches the error and provides instructions on how to install RSAT.

.EXAMPLE
    PS> .\ListADComputers.ps1
    Active Directory Computers:
    Name            OperatingSystem            LastLogonDate
    ----            ----------------            -------------
    PC1             Windows 10 Pro              2023-09-25
    SERVER01        Windows Server 2019         2023-09-24
    
    Finished script at '2024-09-25 12:34:56Z'. Took '00:00:05.1234567' to run.

.DETAILS
    The script will attempt to retrieve AD computers with the `Get-ADComputer` cmdlet. If an error occurs, likely due to 
    missing RSAT, the script outputs a helpful message with a link to install RSAT for Windows 11.

.Output
    Table: Outputs a table of Active Directory computer details, including Name, Operating System, and Last Logon Date.

.LINK
    https://techcommunity.microsoft.com/t5/windows-11/how-to-install-or-uninstall-rsat-in-windows-11/m-p/3273590

.AUTHOR
    tranquilcarbon
    Date: 2025/09/2024
#>




begin {
    # Display the time that this script started running.
    [DateTime] $startTime = Get-Date
    Write-Information "Starting script at '$($startTime.ToString('u'))'."
  
    # Main part of script
    write-host "Active Directory Computers:"
    try{
Get-ADComputer -Filter * -Property Name, OperatingSystem, LastLogonDate | 
    Select-Object Name, OperatingSystem, LastLogonDate
    }
    catch{
        write-host "An error has occured trying to list all Active Directory computers." -foregroundcolor red
        write-host "This is usually caused by RSAT (Remote Server Administration Tools) not being installed." -foregroundcolor red
        write-host "Install RSAT from https://techcommunity.microsoft.com/t5/windows-11/how-to-install-or-uninstall-rsat-in-windows-11/m-p/3273590" -foregroundcolor blue
    }
}
  
  end{
  [DateTime] $finishTime = Get-Date
  [TimeSpan] $elapsedTime = $finishTime - $startTime
  write-host "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run."
  }

