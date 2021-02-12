Function Get-MrkNetworkMxCfRule{
    <#
    .SYNOPSIS
    Retrieves all Meraki MX ContentFiltering rules for a given Meraki network Id.
    For MX series the ContentFiltering rules are retrieved per NetworkID.
        {{baseUrl}}/networks/{{networkId}}/contentFiltering
    .DESCRIPTION
    Gets a list of all Meraki L3 ContentFiltering rules for a given Meraki network.
    .EXAMPLE
    Get-MrkNetworkMxCfRule -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/ContentFiltering')
    return $request
}