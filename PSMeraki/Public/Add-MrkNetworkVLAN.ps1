function Add-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the Network ID, to find an id use get-MrkNetwork
    .EXAMPLE
    Add-MrkNetworkVLAN -Networkid X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0/24 -applianceIP 10.11.12.254
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
        -reservedIpRanges "start-ip1,end-ip1,description1","start-ip2,end-ip2,description2",etc.
    For example: -reservedIpRanges "10.0.0.1,10.0.0.9,AccessPoints","10.0.0.10,10.0.0.19,Switches","10.0.0.20,10.0.0.29,Printers"
    The provided value(s) will be converted into the correct format as accepted by the API.
    .PARAMETER dhcpHandling
    Parameter to set dhcp service on or off. By default the meraki MX servers as a dhcp server for each VLAN.
    The setting can be "Do not respond to DHCP requests" or "Run a DHCP server" or "Relay DHCP to another server"
    .PARAMETER dhcpBootOptionsEnabled
    Parameter ($true or $false) to enable or disable the support for advanced DHCP control
    .PARAMETER dhcpBootNextServer
    Parameter (string value) to specify the TFTP / PXE server to retrieve the bootfile from. Specify the IP or Hostname.
    If a hostname is provided the DNS server must be able to resolve this name.
    Only valid when the dhcpBootOptionsEnabled parameter is $true
    .PARAMETER dhcpBootFilename
    Parameter (string value) to provide the name of the bootfile the system will use for the TFTP/PXE boot.
    .PARAMETER dhcpOptions
    Parameter (multivalued string value) to specify various options. This parameter must be provided as follows: code; type; value
        -dhcpoptions "2;integer;60","26;integer;1234","42;ip;192.168.128.2"
    The provided value(s) will be converted into the correct format as accepted by the API.
    .PARAMETER fixedIpAssignments
    Parameter (multivalued string value) to specify the IP reservations for the DHCP server. Only valid if the dhcpHandling is "Run a DHCP server"
    This parameter must be provided as follows: "mac_address1;reserved_ip1;name1"[,"mac_address2;reserved_ip2;name2",etc]
    For example: -fixedIpAssignments "00:e0:db:21:0f:f9;10.13.90.31;hostname1","00:e0:db:48:7f:ba;10.13.90.32;hostname2"
    .PARAMETER dhcpRelayServerIps
    Parameter (multivalued string value) to specify the remote IP-address(es) to forward the DHCO request to.
    These IPs must be reachable either locally or remote via the site to site VPN.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$id,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$name,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$subnet,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$applianceIp,
        [Parameter()][ValidateNotNullOrEmpty()][string[]]$dnsNameservers,
        [Parameter()][ValidateNotNullOrEmpty()][string[]]$reservedIpRanges,
        [Parameter()][ValidateSet("Do not respond to DHCP requests", "Run a DHCP server", "Relay DHCP to another server")]
            [string]$dhcpHandling,
        [Parameter()][bool]$dhcpBootOptionsEnabled,
        [Parameter()][string]$dhcpBootNextServer,
        [Parameter()][string]$dhcpBootFilename,
        [Parameter()][string[]]$dhcpOptions,
        [Parameter()][string[]]$fixedIpAssignments,
        [Parameter()][string[]]$dhcpRelayServerIps
    )

    $body = @{}

    foreach ($key in $PSBoundParameters.keys){
        switch($key){
            "reservedIpRanges" {
                # if($null -ne $reservedIpRanges){
                #     $tmpCol = @()
                #     forEach($res in $reservedIpRanges){
                #         $tmpCol += New-Object -TypeName PSObject -Property @{
                #             start = ($res.split(","))[0]
                #             end = ($res.split(","))[1]
                #             comment = ($res.split(","))[2]
                #         }
                #     }
                #     [array]$ArrReservedIpRanges = $tmpCol
                # }
                # $body.$key = $ArrReservedIpRanges
            }
            "dnsNameservers" {
                $body.$key = $dnsNameservers -join "`n"
            }
            "fixedIpAssignments" {
                #check if the format is correct: 3 ;-separated parameters in the multivalue string-array
                $fiaColl = @{}
                foreach ($fia in $PSBoundParameters.item($key)){
                    $fiaMac = ($fia -split ";")[0]
                    $fiaIP = ($fia -split ";")[1]
                    $fiaName = ($fia -split ";")[2]
                    $fiaColl.$fiaMac = @{ip = $fiaIP; name = $fiaName}
                }
                $body.$key = $fiaColl
            }
            Default {$body.$key = $PSBoundParameters.item($key)}
        }
    }

    write-verbose $($body | ConvertTo-Json -Depth 10)

    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkId + '/vlans') -Body $body

    #During POST (create new) VLAN the API doesn't handle the setting for DHCP mode other than 'Run a DHCP server'. By default the DHCP mode is enabled. In case the DHCP must be off,
    # the Update-MrkNetworkVLAN function is called to update the Network VLAN DHCP setting using the same variables for the POST action.
    #Additionally the REST API ignores the $dnsNameservers value during the POST and always sets "upstream_dns" which is also corrected during the update (PUT) call 
    If ($dhcpHandling -eq "Do not respond to DHCP requests" -or $dnsNameservers -ne "upstream_dns"){
        $request = Update-MrkNetworkVLAN -networkId $networkId -id $id -name $name -subnet $subnet -applianceIp $applianceIp -dhcpHandling $dhcpHandling -dnsNameservers $dnsNameservers -reservedIpRanges $reservedIpRanges
        return $request
    } else {
        return $request
    }
}