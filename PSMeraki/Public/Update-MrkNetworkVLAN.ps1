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
    To reset/clear reservedIpRanges: -reservedIpRanges $null -reset 
    .PARAMETER dhcpHandling
    Parameter to set dhcp service on or off. By default the meraki MX servers as a dhcp server for each VLAN.
    The setting can be "Do not respond to DHCP requests" or "Run a DHCP server" or "Relay DHCP to another server"
    .PARAMETER dhcpBootOptionsEnabled
    Parameter ($true or $false) to enable or disable the support for advanced DHCP control. When set to $false the code handles removal of the 
    properties dhcpBootNextServer and dhcpBootFilename.
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
    To reset/clear fixedIpAssignments: -fixedIpAssignments $null -reset 
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
        [Parameter()][string[]]$dnsNameservers,
        [Parameter()][string[]]$reservedIpRanges,
        [Parameter(ParameterSetName='dhcpenabled',Mandatory=$true)][ValidateSet("Do not respond to DHCP requests", "Run a DHCP server", "Relay DHCP to another server")]
            [string]$dhcpHandling,
        [Parameter(ParameterSetName='dhcpenabled')]
        [Parameter(ParameterSetName='dhcpBootOptions')]
        [ValidateSet($true,$false)]
            [bool]$dhcpBootOptionsEnabled,
        [Parameter(ParameterSetName='dhcpenabled')]
        [Parameter(ParameterSetName='dhcpBootOptions',Mandatory=$true)]
            [string]$dhcpBootNextServer,
        [Parameter(ParameterSetName='dhcpenabled')]
        [Parameter(ParameterSetName='dhcpBootOptions',Mandatory=$true)]
            [string]$dhcpBootFilename,
        [Parameter(ParameterSetName='dhcpenabled')][string[]]$dhcpOptions,
        [Parameter()][string[]]$fixedIpAssignments,
        [Parameter()][string[]]$dhcpRelayServerIps,
        [switch]$reset
    )

    begin{
        #$mrkConfig = @{}
        $mrkConfig = Get-MrkNetworkVLAN -networkId $networkId -id $id;
    }
    
    Process{
        #only privided parameters are processed which will update the parameter in the retrieved body
        foreach ($key in $PSBoundParameters.keys){
            switch($key){
                "reservedIpRanges" {
                    if($reset){$tmpCol = @()}
                    else{$tmpCol = $mrkConfig.$key}

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
                    $mrkConfig.$key = $reservedIpRanges
                }
                "dhcpOptions" {
                    #-dhcpoptions "15,text,domain.suffix","2,integer,60","26,integer,1234","42,ip,192.168.128.2"
                    # in case the dhcpService wasn't active and is activated now with dhcpOptions then the $dhcpOptionsColl has to be created as empty array...
                    if( $reset -or $null -eq ($mrkConfig | Get-Member dhcpOptions) ){$dhcpOptionsColl = @()}
                    else{$dhcpOptionsColl = $mrkConfig.$key}

                    if($dhcpOptions.Length -ne 0){
                        forEach($option in $dhcpOptions){
                            $optionProps = $option.split(",")
                            #check if the current status of dhcpOptionsColl already contains the provided option-code as they can only contain 1 of each
                            if ($dhcpOptionsColl.code -notcontains $optionProps[0] ){
                                $dhcpOptionsColl += New-Object -TypeName PSObject -Property @{
                                    code = $optionProps[0]
                                    type = $optionProps[1]
                                    value = $optionProps[2]
                                }
                            }
                        }
                    }
                    #[array]$reservedIpRanges = $tmpCol
                    #in case the dhcp service wasn't active on the vlan prior to running this function the member dhcpOptions doesn't exist. use add-member -force to 
                    #make it work for both cases where it wasn't present before or update existing value
                    $mrkConfig | Add-Member -MemberType NoteProperty -Name $key -Value $dhcpOptionsColl -Force

                }
                "dnsNameservers" {
                    $mrkConfig.$key = $dnsNameservers -join "`n"
                }
                "fixedIpAssignments" {
                    #check if the format is correct: 3 ,-separated parameters in the multivalue string-array
                    if($reset){$fiaColl = [PSCustomObject]@{}}
                    else{$fiaColl = $mrkConfig.$key}

                    if($fixedIpAssignments.Length -ne 0){
                        foreach ($fia in $fixedIpAssignments){
                            $fiaProps = $fia -split ","

                            $fiaMac = $fiaProps[0]
                            $fiaIP = $fiaProps[1]
                            $fiaName = $fiaProps[2]

                            $fiaColl | Add-Member -MemberType NoteProperty -name $fiaMac -value @{ip = $fiaIP; name = $fiaName}
                        }
                    }
                    $mrkConfig.$key = $fiaColl
                }
                "dhcpBootOptionsEnabled" {
                    if($false -eq $dhcpBootOptionsEnabled){
                        $mrkConfig.psobject.properties.Remove('dhcpBootFilename')
                        $mrkConfig.psobject.properties.Remove('dhcpBootNextServer')
                    }
                    $mrkConfig.$key = $dhcpBootOptionsEnabled
                }
                {$_ -in "reset"} {
                    #in case a powershell parameter is just to control a value (e.g -reset) add is not a parameter that exists in
                    #the mrkConfig add it here in the -in "reset","another1","another2"
                }
                Default {
                    $mrkConfig | Add-Member -MemberType NoteProperty -Name $key -Value $PSBoundParameters.item($key) -Force
                    #$mrkConfig.$key = $PSBoundParameters.item($key)
                }
            }
        }

        write-verbose $($mrkConfig | ConvertTo-Json -Depth 10)

        $request = Invoke-MrkRestMethod -Method Put -ResourceID ('/networks/' + $networkId + '/vlans/' + $id) -Body $mrkConfig
        return $request
    }

    End{}
}
