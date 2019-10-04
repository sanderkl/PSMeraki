function Get-MrkNetworkIDPSetting {
    <#
    .SYNOPSIS
    Retrieves the Network Security Intrusion Settings applied to a network
    .DESCRIPTION
    Describe the function in more detail
    .EXAMPLE
    Get-MrkNetworkIDPSetting 
    .EXAMPLE
    Get-MrkNetworkIDPSetting -networkId L_564638803281579210
    .PARAMETER networkId
    optional parameter to specify a specific networkId. This function-call for example used to dynamically retrieve a specific
    network and then use the retrieved id to get settings from that specific network like vlans and vlan enabled status
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$networkId
    )

    #{baseUrl}/networks/{networkId}/security/intrusionSettings
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/security/intrusionSettings');

    return $request
}