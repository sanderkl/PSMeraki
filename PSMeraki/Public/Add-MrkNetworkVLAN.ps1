function Add-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the networkId, to find an id use get-MrkNetwork
    .EXAMPLE
    Add-MrkNetworkVLAN -networkId X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0 -applianceIP 10.11.12.254
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
        [ipv4],[ipv4],[ipv4],.. the script joins these into a string with new-line character `n as separation
    .PARAMETER reservedIpRanges
    the reservedIpRanges is an array object where each entry is a fixed format:
    "reservation1","reservation2",etc
     "start-ip1,end-ip1,description1","start-ip2,end-ip2,description2",etc
    .PARAMETER dhcpHandling
    parameter to set dhcp service on or off. By default the meraki MX servers as a dhcp server for each VLAN.
    the setting can be "Do not respond to DHCP requests", "Run a DHCP server", or a 
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
        [Parameter()][ValidateSet("Do not respond to DHCP requests", "Run a DHCP server")]
        [string]$dhcpHandling
    )

    #$config = Get-MrkNetworkVLAN -networkId $networkId -id 
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
        "name" = $Name
        "applianceIp" = $applianceIP
        "subnet" = $Subnet
        "dnsNameservers" = $dnsNameservers -join "`n"
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