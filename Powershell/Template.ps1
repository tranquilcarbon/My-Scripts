<#
.SYNOPSIS
    Displays all colours the terminal can use.

.DESCRIPTION
    Powershell can use several colours to display results, green for example is
    used to display success. This script lets you see all colours.

.EXAMPLE
    1. Run script
    2. Colours will display.

.DETAILS
    Permissions: Standard
    Requirements: Colour display, Terminal capable of displaying colour.
.Output
    See https://i.imgur.com/UBVUBZU.png 
.LINK

.AUTHOR
    tranquilcarbon
    Date: 20/09/2024
#>




begin {
  # Display the time that this script started running.
  [DateTime] $startTime = Get-Date
  Write-Information "Starting script at '$($startTime.ToString('u'))'."

  # Main part of script

}

end{
[DateTime] $finishTime = Get-Date
[TimeSpan] $elapsedTime = $finishTime - $startTime
write-host "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run."
}