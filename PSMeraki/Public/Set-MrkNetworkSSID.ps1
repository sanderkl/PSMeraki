function Set-MrkNetworkSSID {
    <#
    .SYNOPSIS
    Sets propeerties on a given Meraki SSID number on a Meraki network
    PUT {orguri}/networks/{networkId}/ssids/{number}
    .DESCRIPTION
    Gets a list of all Meraki SSIDs on a Meraki network.
    .EXAMPLE
    Set-MrkNetworkSSID -networkId X_112233445566778899 -number 1 -name "Company Network" -enabled $true -authMode psk -
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER number
    numbers 0 to 14 to identify the SSID hardcoded numeric value to set/update
    .PARAMETER name
    The name of an SSID
    .PARAMETER enabled
    boolean parameter to specify the state of the SSID [$true/$false]
    .PARAMETER authMode
    ('open', 'psk', 'open-with-radius', '8021x-meraki', '8021x-radius')
    .PARAMETER encryptionMode
    ('wpa', 'wep' or 'wpa-eap')
    .PARAMETER psk
    The passkey for the SSID. This param is only valid if the authMode is 'psk'
    .PARAMETER wpaEncryptionMode
    ('WPA1 and WPA2', 'WPA2 only')
    .PARAMETER splashPage
    The type of splash page for the SSID ('None', 'Click-through splash page', 'Billing',
    'Password-protected with Meraki RADIUS', 'Password-protected with custom RADIUS',
    'Password-protected with Active Directory', 'Password-protected with LDAP', 'SMS authentication',
    'Systems Manager Sentry', 'Facebook Wi-Fi', 'Google OAuth' or 'Sponsored guest').
    This attribute is not supported for template children.
    .PARAMETER radiusServers
    The RADIUS 802.1x servers to be used for authentication. This param is only valid if the authMode is 'open-with-radius' or '8021x-radius'
    host  : IP address of your RADIUS server
    port  : UDP port the RADIUS server listens on for Access-requests
    secret: RADIUS client shared secret
    .PARAMETER radiusCoaEnabled
    If true, Meraki devices will act as a RADIUS Dynamic Authorization Server and will respond to RADIUS Change-of-Authorization and
    Disconnect messages sent by the RADIUS server.
    .PARAMETER radiusFailoverPolicy
    This policy determines how authentication requests should be handled in the event that all of the configured RADIUS servers are unreachable
    ('Deny access' or 'Allow access')
    .PARAMETER radiusLoadBalancingPolicy
    This policy determines which RADIUS server will be contacted first in an authentication attempt and the ordering of any necessary retry attempts
    ('Strict priority order' or 'Round robin')
    .PARAMETER radiusAccountingEnabled
    Whether or not RADIUS accounting is enabled. This param is only valid if the authMode is 'open-with-radius' or '8021x-radius'
    .PARAMETER radiusAccountingServers
    The RADIUS accounting 802.1x servers to be used for authentication. This param is only valid if the authMode is 'open-with-radius' or '8021x-radius'
    and radiusAccountingEnabled is 'true'
    host   : IP address to which the APs will send RADIUS accounting messages
    port   : Port on the RADIUS server that is listening for accounting messages
    secret : Shared key used to authenticate messages between the APs and RADIUS server
    .PARAMETER ipAssignmentMode
    The client IP assignment mode ('NAT mode','Bridge mode','Layer 3 roaming','Layer 3 roaming with a concentrator','VPN')
    .PARAMETER useVlanTagging
    Direct trafic to use specific VLANs. This param is only valid with 'Bridge mode' and 'Layer 3 roaming'
    .PARAMETER concentratorNetworkId
    The concentrator to use for 'Layer 3 roaming with a concentrator' or 'VPN'.
    .PARAMETER vlanId
    The VLAN ID used for VLAN tagging. This param is only valid with 'Layer 3 roaming with a concentrator' and 'VPN'
    .PARAMETER defaultVlanId
    The default VLAN ID used for 'all other APs'. This param is only valid with 'Bridge mode' and 'Layer 3 roaming'
    .PARAMETER apTagsAndVlanIds
    The list of tags and VLAN IDs used for VLAN tagging. This param is only valid with 'Bridge mode','Layer 3 roaming'
    tags   : Comma-separated list of AP tags
    vlanId : Numerical identifier that is assigned to the VLAN
    .PARAMETER walledGardenEnabled
    Allow access to a configurable list of IP ranges, which users may access prior to sign-on.
    .PARAMETER walledGardenRanges
    Specify your walled garden by entering space-separated addresses, ranges using CIDR notation, domain names,
    and domain wildcards (e.g. 192.168.1.1/24 192.168.37.10/32 www.yahoo.com *.google.com). Meraki's splash page is automatically included in your walled garden.
    .PARAMETER minBitrate
    The minimum bitrate in Mbps. ('1','2','5.5','6','9','11','12','18','24','36','48','54')
    .PARAMETER bandSelection
    The client-serving radio frequencies. ('Dual band operation','5 GHz band only','Dual band operation with Band Steering')
    .PARAMETER perClientBandwidthLimitUp
    The upload bandwidth limit in Kbps. (0 represents no limit.)
    .PARAMETER perClientBandwidthLimitDown
    The download bandwidth limit in Kbps. (0 represents no limit.)
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory,HelpMessage="Provide a number between 0 and 15")][int]$number,
        [Parameter(Mandatory)][string]$name,
        [Parameter(Mandatory)][bool]$enabled,
        [Parameter()][ValidateSet('None', 'Click-through splash page', 'Billing', 'Password-protected with Meraki RADIUS', 'Password-protected with custom RADIUS', 'Password-protected with Active Directory', 'Password-protected with LDAP', 'SMS authentication', 'Systems Manager Sentry', 'Facebook Wi-Fi', 'Google OAuth', 'Sponsored guest')]
        [String]$splashPage,
        [Parameter(Mandatory)][ValidateSet("open","psk","open-with-radius","8021x-meraki","8021x-radius")][String]$authMode,
        [Parameter()][String]$psk,
        [Parameter(Mandatory)][ValidateSet('wpa','wep','wpa-eap')][String]$encryptionMode,
        [Parameter(Mandatory)][ValidateSet('WPA1 and WPA2','WPA2 only')][String]$wpaEncryptionMode,
        [Parameter(Mandatory)][ValidateSet('NAT mode','Bridge mode','Layer 3 roaming','Layer 3 roaming with a concentrator','VPN')][String]$ipAssignmentMode,
        [Parameter()][ValidateSet('1','2','5.5','6','9','11','12','18','24','36','48','54')][int]$minBitrate,
        [Parameter()][bool]$useVlanTagging,
        [Parameter()][int]$vlanId,
        [Parameter()][int]$defaultVlanId,
        [Parameter()][ValidateSet('Dual band operation', '5 GHz band only', 'Dual band operation with Band Steering')][string]$bandSelection,
        [Parameter()][int]$perClientBandwidthLimitUp,
        [Parameter()][int]$perClientBandwidthLimitDown,
        [Parameter(HelpMessage="format 'servername_or_ip,server_port,secret'")][string[]]$radiusServers,
        [Parameter()][bool]$radiusAccountingEnabled,
        [Parameter(HelpMessage="format 'servername_or_ip,server_port,secret'")][string[]]$radiusAccountingServers,
        [Parameter()][bool]$radiusCoaEnabled,
        [Parameter()][ValidateSet('Deny access','Allow access')][string]$radiusFailoverPolicy,
        [Parameter()][Validateset('Strict priority order','Round robin')][string]$radiusLoadBalancingPolicy,
        [Parameter()]$concentratorNetworkId,
        [Parameter()]$walledGardenEnabled,
        [Parameter()]$walledGardenRanges,
        [Parameter()]$apTagsAndVlanIds
    )
    #validate parameter-dependencies for psk, radius type authentication
    if (($authMode -eq '8021x-radius' -or $authMode -eq 'open-with-radius') -and $null -eq $radiusServers){
        $radiusServers=read-host -Prompt "the radiusserver(s) must be provided. Enter the parameters like 'radiusserver1,port,secret', 'radiusserver2,port,secret', '...' ";$PSBoundParameters += @{radiusServers = '1.2.3.4,1234,qwert'}
    }
    if ($authMode -eq 'psk' -and "" -eq $psk){
        $psk = read-host -Prompt "the psk key must be provided when authMode equals 'psk'";
        $PSBoundParameters += @{psk = $psk}
    }
    if($useVlanTagging -and $ipAssignmentMode -notin 'Bridge mode', 'Layer 3 roaming'){
        Write-Host "useVlanTagging is set to TRUE but the ipAssignmentMode is either not set or not one of 'Bridge mode' or 'Layer 3 roaming'"
        Write-Host "change the ipAssignmentMode or useVlanTagging to FALSE and run the command again"
        break
    }
    if($ipAssignmentMode -in 'Bridge mode', 'Layer 3 roaming' -and $defaultVlanId -eq 0){
        $defaultVlanId = read-host -Prompt "the -defaultVlanId parameter must be provided when ipAssignmentMode equals 'Bridge mode' or 'Layer 3 roaming'. Pls type the id number";
        $PSBoundParameters += @{defaultVlanId = $defaultVlanId}
    }
    if($ipAssignmentMode -in 'Layer 3 roaming with a concentrator', 'VPN' -and $vlanId -eq 0){
        $vlanId = read-host -Prompt "the -vlanId parameter must be provided when ipAssignmentMode equals 'Bridge mode' or 'Layer 3 roaming'. Pls type the id number";
        $PSBoundParameters += @{vlanId = $vlanId}
    }

    $body = [PSCustomObject]@{}
    #add the other properties to the $body as noteproperties based on parameter value present or not
    foreach ($key in $PSBoundParameters.keys){
        if($key -eq 'radiusServers' -or $key -eq 'radiusAccountingServers'){
            $valArray = @()
            foreach($serverParam in $PSBoundParameters.item($key)){
                #format like 'servername/ip','serverport','secret'
                $server = $serverParam.split(",")[0]
                $port = $serverParam.split(",")[1]
                $secret = $serverParam.split(",")[2]
                if ($null -eq $secret){$secret = Read-Host -Prompt 'provide the radius-secret for server $server'}
                $value = [pscustomobject]@{
                    host = $server
                    port = $port
                    secret = $secret
                }
                $valArray += $value
            }
            $body | Add-Member -MemberType NoteProperty -Name $key -Value $valArray
        } elseif ($key -ne 'networkId') {
            $body | Add-Member -MemberType NoteProperty -Name $key -Value $PSBoundParameters.item($key)
        }
    }
    Invoke-MrkRestMethod -Method PUT -ResourceID "/networks/$networkId/ssids/$number" -body $body
}