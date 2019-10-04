function Get-MrkOrgIDPSetting {
    <#
    .SYNOPSIS
    Returns all supported intrusion settings for an organization
    .DESCRIPTION
    Returns all supported intrusion settings for an organization
    .EXAMPLE
    Get-MrkNetworkIDPSetting 
    .EXAMPLE
    Get-MrkNetworkIDPSetting -orgId L_564638803281579210 | select -ExpandProperty whitelistedRules
    .PARAMETER orgId
    optional parameter to specify a specific networkId. This function-call for example used to dynamically retrieve a specific
    network and then use the retrieved id to get settings from that specific network like vlans and vlan enabled status
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][string]$orgId = (Get-MrkFirstOrgID)
    )

    #{baseUrl}/networks/{networkId}/security/intrusionSettings
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $orgId + '/security/intrusionSettings');

    return $request
}