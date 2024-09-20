<#
.SYNOPSIS
    This script lists all logical drives and provides details about each drive, including fixed drives.

.DESCRIPTION
    The script retrieves information about all logical drives on the system, displaying details such as 
    device ID, drive type, file system, free space, and total size. 
    It includes a function to convert drive types into human-readable descriptions. 
    Additionally, it provides a separate listing for fixed drives only.

.EXAMPLE
    PS> .\ListDrives.ps1
    Listing all logical drives:
    
    DeviceID DriveType        FileSystem FreeSpace Size
    --------- ---------        ---------- ----------- ----
    C:       Local Disk       NTFS      200.50     500.00
    D:       Removable Disk   FAT32     15.20      32.00
    
    Listing only fixed drives:
    
    DeviceID DriveType        FileSystem FreeSpace Size
    --------- ---------        ---------- ----------- ----
    C:       Local Disk       NTFS      200.50     500.00

.DETAILS
    This script uses WMI to query logical drives and retrieves properties for each drive. 
    It provides formatted output for both all logical drives and a filtered list for fixed drives.

.Output
    Object: Outputs a formatted table of drive details for all logical drives and another for fixed drives.

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
# Function to convert DriveType to human-readable format
function Get-DriveTypeDescription {
    param (
        [int]$DriveType
    )

    switch ($DriveType) {
        0 { return "Unknown" }
        1 { return "No Root Directory" }
        2 { return "Removable Disk" }
        3 { return "Local Disk" }
        4 { return "Network Drive" }
        5 { return "Compact Disc" }
        6 { return "RAM Disk" }
        default { return "Unknown" }
    }
}

# Function to list all logical drives
function Get-LogicalDrives {
    $logicalDrives = Get-WmiObject -Class Win32_LogicalDisk

    foreach ($drive in $logicalDrives) {
        [PSCustomObject]@{
            DeviceID   = $drive.DeviceID
            DriveType  = Get-DriveTypeDescription -DriveType $drive.DriveType
            FileSystem = $drive.FileSystem
            FreeSpace  = [math]::round($drive.FreeSpace / 1GB, 2)
            Size       = [math]::round($drive.Size / 1GB, 2)
        }
    }
}

# Function to list only fixed drives
function Get-FixedDrives {
    $fixedDrives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

    foreach ($drive in $fixedDrives) {
        [PSCustomObject]@{
            DeviceID   = $drive.DeviceID
            DriveType  = Get-DriveTypeDescription -DriveType $drive.DriveType
            FileSystem = $drive.FileSystem
            FreeSpace  = [math]::round($drive.FreeSpace / 1GB, 2)
            Size       = [math]::round($drive.Size / 1GB, 2)
        }
    }
}

# Main script execution
Write-Output "Listing all logical drives:"
Get-LogicalDrives | Format-Table -AutoSize

Write-Output "`nListing only fixed drives:"
Get-FixedDrives | Format-Table -AutoSize
      }
  
  end{
  [DateTime] $finishTime = Get-Date
  [TimeSpan] $elapsedTime = $finishTime - $startTime
  write-host "Finished script at '$($finishTime.ToString('u'))'. Took '$elapsedTime' to run."
  }

