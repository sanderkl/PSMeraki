function Get-MrkNetworkGroupPolicy {
    <#
    .SYNOPSIS
    Retrieves all group policies for a Meraki network
    .DESCRIPTION
    Gets a list of all group policies in a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkGroupPolicy -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/groupPolicies')
    return $request
}