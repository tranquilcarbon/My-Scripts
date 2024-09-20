<#
.SYNOPSIS
    This script retrieves information about network adapters, IP configurations, and the public IP address.

.DESCRIPTION
    The script gathers and displays details about the system's network adapters, including their name, MAC address, status, and link speed. 
    It also retrieves IP configurations for each adapter, including both IPv4 and IPv6 addresses. 
    Additionally, it uses an external service to fetch and display the system's public IP address.

.EXAMPLE
    PS> .\NetworkInfo.ps1
    Network Adapters:
    Name         : Ethernet
    MacAddress   : 00-14-22-01-23-45
    Status       : Up
    LinkSpeed    : 1 Gbps

    IP Configurations:
    InterfaceAlias    : Ethernet
    IPv4Address       : 192.168.1.100
    IPv6Address       : fe80::1c15:22ff:fe2e:6c1a
    InterfaceDescription : Realtek PCIe GBE Family Controller
    
    Public IP Address:
    203.0.113.42

.DETAILS
    This script uses `Get-NetAdapter` and `Get-NetIPConfiguration` cmdlets to retrieve detailed network information. 
    It also calls an external API (https://api.ipify.org) to determine the system's public IP address.

.Output
    Object: Outputs network adapter details, IP configurations, and the public IP address as structured data.

.LINK
    https://api.ipify.org - Used to inquire public IP

.AUTHOR
    tranquilcarbon
    Date: 20/09/2024
#>


begin {
    # No time elapsed because Powershell is stubborn
    # Main part of script
    $networkAdapters = Get-NetAdapter | Select-Object Name, MacAddress, Status, LinkSpeed

    # Get IP configuration for network adapters
    $ipConfigurations = Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv6Address, InterfaceDescription
    
    # Retrieve public IP address using an external service
    $publicIp = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json'
    
    # Output the results
    "Network Adapters:"
    $networkAdapters
    "IP Configurations:"
    $ipConfigurations
    "Public IP Address:"
    $publicIp.ip
  }