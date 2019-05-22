Function Get-MrkNetworkMxCfRule{
    <#
    .SYNOPSIS
    Retrieves all Meraki MX ContentFiltering rules for a given Meraki network Id.
    For MX series the ContentFiltering rules are retrieved per NetworkID.
        {{baseUrl}}/networks/{{networkId}}/contentFiltering
    .DESCRIPTION
    Gets a list of all Meraki L3 ContentFiltering rules for a given Meraki network. 
    .EXAMPLE
    Get-MrkNetworkMxCfRule -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/ContentFiltering')
    return $request
}