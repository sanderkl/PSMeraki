function Update-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the Network ID, to find an id use get-MrkNetwork
    .EXAMPLE
    Update-MrkNetworkVLAN -Networkid X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0 -applianceIP 10.11.12.254
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER id
    VLAN id, a number between 1 and 4094
    .PARAMETER Name
    The Name of the new VLAN
    .PARAMETER subnet
    The subnet of the VLAN 
    .PARAMETER applianceIP
    The local IP of the appliance on the VLAN 
    .PARAMETER dnsNameservers
    valid dnsNameservers values are:
        "upstream_dns"
        "opendns"
        "google_dns"
        "[ipv4]\n[ipv4]\n[ipv4]..."
    .PARAMETER reservedIpRanges
    the reservedIpRanges is an array object where each entry is a fixed format:
    "reservation1","reservation2"
     "start-ip1,end-ip1,description1","start-ip2,end-ip2,description2",etc
    .PARAMETER dhcpHandling
    parameter to set dhcp service on or off. By default the meraki MX servers as a dhcp server for each VLAN.
    the setting can be "Do not respond to DHCP requests", "Run a DHCP server", or a 
    .Notes
    
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$id,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$name,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$subnet,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$applianceIp,
        [Parameter()][string]$dnsNameservers,
        [Parameter()][array]$reservedIpRanges,
        [Parameter()][ValidateSet("","Do not respond to DHCP requests", "Run a DHCP server")]
        [string]$dhcpHandling
    )
    
    $body  = @{
        "id" = $Id
        "networkId" = $networkId
        "name" = $name
        "applianceIp" = $applianceIP
        "subnet" = $subnet
        "dnsNameservers" = $dnsNameservers
        "reservedIpRanges" = $reservedIpRanges
        "dhcpHandling" = $dhcpHandling
    }
    $request = Invoke-MrkRestMethod -Method Put -ResourceID ('/networks/' + $Networkid + '/vlans/' + $Id) -Body $body  
    return $request
}
