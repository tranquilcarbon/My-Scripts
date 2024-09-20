<#
.SYNOPSIS
    This script displays the available console colors in PowerShell.

.DESCRIPTION
    The script enumerates all available console colors and prints each color's name in both its foreground 
    and background variations. It provides a visual representation of each color option available in the console.

.EXAMPLE
    PS> .\DisplayConsoleColors.ps1
    Red
    Green
    Blue
    ...
    (Colors are displayed with their respective formatting)

.DETAILS
    This script uses the `System.ConsoleColor` enumeration to obtain all color values and iterates through them.
    It displays each color name with the appropriate foreground and background color settings, demonstrating 
    how they appear in the console.

.Output
    String: Outputs color names with their respective foreground and background colors.

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
$List = [enum]::GetValues([System.ConsoleColor])

    ForEach ($Color in $List){
        Write-Host "      $Color" -ForegroundColor $Color -NonewLine
        Write-Host ""

    } #end foreground color ForEach loop

    ForEach ($Color in $List){
        Write-Host "                   " -backgroundColor $Color -noNewLine
        Write-Host "   $Color"
	}
}

end{
[DateTime] $finishTime = Get-Date
[TimeSpan] $elapsedTime = $finishTime - $startTime
write-host "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run."
}