function Get-MrkNetworkUplink {
    <#
    .SYNOPSIS
    Function to retrieve the MX uplink settings.
    .DESCRIPTION
    Function to retrieve the MX uplink settings.
    .EXAMPLE
    Get-MrkNetworkUplink -networkId L_112233445566778899
    .PARAMETER networkId
    Specify a networkId, find an id using get-MrkNetworks
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][String]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/uplinkSettings') ;

    return $request
}