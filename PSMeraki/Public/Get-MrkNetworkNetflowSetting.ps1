Function Get-MrkNetworkNetflowSetting{
    <#
    .SYNOPSIS
    Retrieves the NetFlow traffic reporting settings for a network 
    .DESCRIPTION
    Retrieves the NetFlow traffic reporting settings for a network on the provided networkId
    GET /networks/{networkId}/netflowSettings
    .EXAMPLE
    Get-MrkNetworkNetflowSetting -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId
    )
    
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/netflowSettings')
    return $request

}