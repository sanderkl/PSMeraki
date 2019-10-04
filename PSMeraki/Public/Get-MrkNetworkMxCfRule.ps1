Function Get-MrkNetworkMxCfRule{
    <#
    .SYNOPSIS
    Retrieves all Meraki MX contentFiltering rules for a given Meraki network Id.
    For MX series the contentFiltering rules are retrieved per NetworkID.
        {{baseUrl}}/networks/{{networkId}}/contentFiltering
    .DESCRIPTION
    Gets a list of all Meraki L3 contentFiltering rules for a given Meraki network. 
    .EXAMPLE
    Get-MrkNetworkMxCfRule -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/contentFiltering')
    return $request
    
}