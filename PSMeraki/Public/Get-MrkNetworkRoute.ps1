function Get-MrkNetworkRoute {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network Routes for a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network Routes for a Meraki network.
    .EXAMPLE
    Get-MrkNetworkRoute -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using Get-MrkNetworks
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