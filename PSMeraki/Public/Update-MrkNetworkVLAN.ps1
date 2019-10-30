function Update-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Updates settings of a VLAN in a Meraki network
    .DESCRIPTION
    Updates settings of a VLAN in a Meraki network, identifying the network with the Network ID. To find an id use get-MrkNetwork.
    .EXAMPLE
    Update-MrkNetworkVLAN -Networkid X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0/24 -applianceIP 10.11.12.254
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
    Parameter (multivalued string value) to specify various options. This parameter must be provided as follows: code, type, value
        -dhcpoptions "15,text,domain.suffix","2,integer,60","26,integer,1234","42,ip,192.168.128.2"
    The provided value(s) will be converted into the correct format as accepted by the API.
    .PARAMETER fixedIpAssignments
    Parameter (multivalued string value) to specify the IP reservations for the DHCP server. Only valid if the dhcpHandling is "Run a DHCP server"
    This parameter must be provided as follows: "mac_address1,reserved_ip1,name1"[,"mac_address2,reserved_ip2,name2",etc]
    For example: -fixedIpAssignments "00:e0:db:21:0f:f9,10.13.90.31,hostname1","00:e0:db:48:7f:ba,10.13.90.32,hostname2"
    .PARAMETER dhcpRelayServerIps
    Parameter (multivalued string value) to specify the remote IP-address(es) to forward the DHCO request to.
    These IPs must be reachable either locally or remote via the site to site VPN.
    .PARAMETER reset
    Optional SWITCH to control whether the current configured values are kept or overwritten by the provided value.
    E.g when applying an update without the -reset switch will ADD the provided value to the existing value in case the value is 
    a multi-value type setting like fixedIpAssignments, dhcpRelayServerIps, dhcpOptions
    Example:
    add fixedIpAssignments/reservations to vlan 530
    Update-MrkNetworkVLAN -networkId X_111122223639801111 -id 530 -fixedIpAssignments "aa:bb:cc:dd:ee:f1,10.194.243.4,testpc1","aa:bb:cc:dd:ee:f2,10.194.243.5,testpc2","aa:bb:cc:dd:ee:f3,10.194.243.6,testpc3"

    Add only 1 new reservation and remove any existing reservations to vlan 530
    Update-MrkNetworkVLAN -networkId X_111122223639801111 -id 530 -fixedIpAssignments "aa:bb:cc:dd:ee:f1,10.194.243.4,testpc1" -reset

    remove all fixedIpAssignments:
    Update-MrkNetworkVLAN -networkId X_111122223639801111 -id 530 -fixedIpAssignments $null -reset

    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$id,
        [Parameter()][ValidateNotNullOrEmpty()][string]$name,
        [Parameter()][ValidateNotNullOrEmpty()][string]$subnet,
        [Parameter()][ValidateNotNullOrEmpty()][string]$applianceIp,
        [Parameter()][ValidateNotNullOrEmpty()][string[]]$dnsNameservers,
        [Parameter()][ValidateNotNullOrEmpty()][string[]]$reservedIpRanges,
        [Parameter()][ValidateSet("Do not respond to DHCP requests", "Run a DHCP server", "Relay DHCP to another server")]
            [string]$dhcpHandling,
        [Parameter()][bool]$dhcpBootOptionsEnabled,
        [Parameter()][string]$dhcpBootNextServer,
        [Parameter()][string]$dhcpBootFilename,
        [Parameter()][string[]]$dhcpOptions,
        [Parameter()][string[]]$fixedIpAssignments,
        [Parameter()][string[]]$dhcpRelayServerIps,
        [switch]$reset
    )

    #$body = @{}
    $body = Get-MrkNetworkVLAN -networkId $networkId -id $id;

    #only privided parameters are processed which will update the parameter in the retrieved body
    foreach ($key in $PSBoundParameters.keys){
        switch($key){
            "reservedIpRanges" {
                if($reset){$tmpCol = @()}
                else{$tmpCol = $body.$key}

                #if($null -ne $reservedIpRanges){
                if($reservedIpRanges.Length -ne 0){
                    #$tmpCol = @()
                    forEach($res in $reservedIpRanges){
                        $tmpCol += New-Object -TypeName PSObject -Property @{
                            start = ($res.split(","))[0]
                            end = ($res.split(","))[1]
                            comment = ($res.split(","))[2]
                        }
                    }
                }
                [array]$reservedIpRanges = $tmpCol
                $body.$key = $reservedIpRanges
            }
            "dhcpOptions" {
                #-dhcpoptions "15,text,domain.suffix","2,integer,60","26,integer,1234","42,ip,192.168.128.2"
                if($reset){$tmpCol = @()}
                else{$tmpCol = $body.$key}

                if($dhcpOptions.Length -ne 0){
                    forEach($option in $dhcpOptions){
                        $optionProps = $option.split(",")
                        $tmpCol += New-Object -TypeName PSObject -Property @{
                            code = $optionProps[0]
                            type = $optionProps[1]
                            value = $optionProps[2]
                        }
                    }
                    
                }
                [array]$reservedIpRanges = $tmpCol
                $body.$key = $reservedIpRanges
            }
            "dnsNameservers" {
                $body.$key = $dnsNameservers -join "`n"
            }
            "fixedIpAssignments" {
                #check if the format is correct: 3 ,-separated parameters in the multivalue string-array
                if($reset){$fiaColl = [PSCustomObject]@{}}
                else{$fiaColl = $body.$key}

                if($fixedIpAssignments.Length -ne 0){
                    foreach ($fia in $fixedIpAssignments){
                        $fiaProps = $fia -split ","

                        $fiaMac = $fiaProps[0]
                        $fiaIP = $fiaProps[1]
                        $fiaName = $fiaProps[2]

                        $fiaColl | Add-Member -MemberType NoteProperty -name $fiaMac -value @{ip = $fiaIP; name = $fiaName}
                    }
                }
                $body.$key = $fiaColl
            }
            "reset" {}
            Default {$body.$key = $PSBoundParameters.item($key)}
        }
    }

    write-verbose $($body | ConvertTo-Json -Depth 10)

    $request = Invoke-MrkRestMethod -Method Put -ResourceID ('/networks/' + $networkId + '/vlans/' + $id) -Body $body
    return $request
}
