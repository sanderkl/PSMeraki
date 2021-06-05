Function Get-MrkNetworkStaticRoute{
    <#
    #>
    <#
    .SYNOPSIS
    Returns the Static Route(s) of a Meraki network
    .DESCRIPTION
    Returns the Static Route(s) of a Meraki network, identifying the network with the Network ID. To find an id use get-MrkNetwork
    .EXAMPLE
    Get-MrkNetworkStaticRoute -Networkid X_111122223639801111
    .PARAMETER Networkid
    id of a network (get-MrkNetworks)[0].id
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/staticRoutes"
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/appliance/staticRoutes"
    }
}