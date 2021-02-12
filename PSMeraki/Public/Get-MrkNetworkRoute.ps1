function Get-MrkNetworkRoute {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network Routes on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network Routes on a Meraki network.
    .EXAMPLE
    Get-MrkNetworkRoute -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/staticRoutes')
    return $request
}