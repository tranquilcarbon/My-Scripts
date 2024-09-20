<#
.SYNOPSIS
    This script continuously monitors and displays the top 15 processes by CPU usage.

.DESCRIPTION
    The script retrieves the current CPU usage percentage for all processes and sorts them in descending order.
    It updates the display in the console, clearing the previous output each time to provide a real-time view of CPU usage.
    The information is formatted as a table for better readability.

.EXAMPLE
    PS> .\MonitorCpuUsage.ps1
    (Displays a continuously updated table of the top 15 processes by CPU usage)

.DETAILS
    This script uses the `Get-Counter` cmdlet to gather performance counter data related to CPU usage. 
    It runs indefinitely in a loop until manually stopped (e.g., with Ctrl+C).
    The output is refreshed regularly, providing a live view of CPU performance.

.Output
    Table: Outputs a formatted table displaying the top 15 processes by their CPU usage percentage.

.LINK
    N/A

.AUTHOR
    Your Name
#>

While(1) {  $p = get-counter '\Process(*)\% Processor Time'; cls; $p.CounterSamples | sort -des CookedValue | select -f 15 | ft -a}