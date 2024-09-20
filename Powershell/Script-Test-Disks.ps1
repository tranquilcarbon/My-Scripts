<#
.SYNOPSIS
    This script runs the `chkdsk` command on all fixed drives in the system.

.DESCRIPTION
    The script retrieves all fixed drives using the Win32_LogicalDisk WMI class and iterates through each drive. 
    It executes the `chkdsk` command with the `/f` flag to fix any file system errors on the specified drives.
    The progress of the operation is logged to the console.

.EXAMPLE
    PS> .\RunChkdsk.ps1
    Running chkdsk on drive C:
    (chkdsk output)
    Running chkdsk on drive D:
    (chkdsk output)
    chkdsk completed on all drives.

.DETAILS
    This script utilizes WMI to query logical drives and filters for fixed drives only (DriveType 3).
    It provides feedback during the execution of `chkdsk` to indicate which drive is currently being checked.

.Output
    String: Outputs the status of `chkdsk` execution for each fixed drive processed.

.LINK
    N/A

.AUTHOR
    Your Name
#>


# Get all logical drives
$drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

# Loop through each drive and run chkdsk
foreach ($drive in $drives) {
    $driveLetter = $drive.DeviceID
    Write-Host "Running chkdsk on drive $driveLetter"
    chkdsk $driveLetter /f
}

Write-Host "chkdsk completed on all drives."

# IMPORTANT NOTE
# If in the future, you want to include other drives, here's the drivetype
# Numbers
# 0: Unknown
# 1: No Root Directory
# 2: Removable Disk
# 3: Local Disk (Fixed drive)
# 4: Network Drive
# 5: Compact Disc
# 6: RAM Disk