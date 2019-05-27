function Update-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the Network ID, to find an id use get-MrkNetwork
    .EXAMPLE
    Update-MrkNetworkVLAN -Networkid X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0 -applianceIP 10.11.12.254
    .PARAMETER networkId 
    id of a network (get-MrkNetworks).id[0]
    .PARAMETER id
    VLAN id, a number between 1 and 4094
    .PARAMETER name
    The Name of the new VLAN
    .PARAMETER subnet
    The subnet of the VLAN 
    .PARAMETER applianceIP
    The local IP of the appliance on the VLAN 
    .PARAMETER dnsNameservers
    Multivalue string (array). valid dnsNameservers values are:
        "upstream_dns"
        "opendns"
        "google_dns"
        [ipv4],[ipv4],[ipv4],.. the script joins these into a string with new-line character `n as separation
    .PARAMETER reservedIpRanges
    "reservation1","reservation2",etc
    The reservedIpRanges input-parameter is Multivalue string (array) object where each entry should be of a fixed format:
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
        [Parameter()][string[]]$dnsNameservers,
        [Parameter()][string[]]$reservedIpRanges,
        [Parameter()][ValidateSet("","Do not respond to DHCP requests", "Run a DHCP server")]
        [string]$dhcpHandling
    )
    #reservedIpRanges string property (IP Reservation(s), comma separated) must be converted into hashtable type to pass it on to the REST API
    if($null -ne $reservedIpRanges){
        $tmpCol = @()
        forEach($res in $reservedIpRanges){
            $tmpCol += New-Object -TypeName PSObject -Property @{
                start = ($res.split(","))[0]
                end = ($res.split(","))[1]
                comment = ($res.split(","))[2]
            }
        }
        [array]$reservedIpRanges = $tmpCol
    }

    $body  = @{
        "id" = $Id
        "networkId" = $networkId
        "name" = $name
        "applianceIp" = $applianceIP
        "subnet" = $subnet
        "dnsNameservers" = $dnsNameservers -join "`n"
        "reservedIpRanges" = $reservedIpRanges
        "dhcpHandling" = $dhcpHandling
    }
    $request = Invoke-MrkRestMethod -Method Put -ResourceID ('/networks/' + $Networkid + '/vlans/' + $Id) -Body $body  
    return $request
}
