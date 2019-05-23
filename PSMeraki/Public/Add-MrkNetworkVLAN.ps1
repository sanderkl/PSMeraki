function Add-MrkNetworkVLAN { # UNTESTED
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the networkId, to find an id use get-MrkNetwork
    .EXAMPLE
    Add-MrkNetworkVLAN -networkId X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0 -applianceIP 10.11.12.254
    .PARAMETER networkId 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER id
    VLAN is, a number between 1 and 4094
    .PARAMETER Name
    The Name of the new VLAN
    .PARAMETER subnet
    The subnet of the VLAN 
    .PARAMETER applianceIP
    The local IP of the appliance on the VLAN 
    .PARAMETER dnsNameservers
    The local IP of the appliance on the VLAN 
    .PARAMETER reservedIpRanges
    The local IP of the appliance on the VLAN 
    .PARAMETER dhcpHandling
    The local IP of the appliance on the VLAN 
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$id,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$name,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$subnet,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$applianceIp,
        [Parameter()][string]$dnsNameservers,
        [Parameter()][array]$reservedIpRanges=@(),
        [Parameter()][ValidateSet("Do not respond to DHCP requests", "Run a DHCP server")]
        [string]$dhcpHandling
    )

    #$config = Get-MrkNetworkVLAN -networkId $networkId -id 

    $body  = @{
        "id" = $Id
        "networkId" = $networkId
        "name" = $Name
        "applianceIp" = $applianceIP
        "subnet" = $Subnet
        "dnsNameservers" = $dnsNameservers
        "reservedIpRanges" = $reservedIpRanges
        "dhcpHandling" = $dhcpHandling
    }

    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkId + '/vlans') -Body $body

    #during POST (create new) VLAN the API doesn't handle the setting for DHCP mode other than 'Run a DHCP server'. By default the DHCP mode is enabled. In case the DHCP must be off,
    # the Update-MrkNetworkVLAN function is called to update the Network VLAN DHCP setting using the same variables for the POST action.
    #additionally the REST API ignores the $dnsNameservers value and always sets "upstream_dns" which is also corrected during the update call 
    If ($dhcpHandling -eq "Do not respond to DHCP requests" -or $dnsNameservers -ne "upstream_dns"){
        $request = Update-MrkNetworkVLAN -networkId $networkId -id $id -name $name -subnet $subnet -applianceIp $applianceIp -dhcpHandling $dhcpHandling -dnsNameservers $dnsNameservers -reservedIpRanges $reservedIpRanges
        return $request
    } else {
        return $request
    }
}