function Get-MrkNetworkGroupPolicy {
    <#
    .SYNOPSIS
    Retrieves all group policies for a Meraki network
    .DESCRIPTION
    Gets a list of all group policies in a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkGroupPolicy -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/groupPolicies')
    return $request
}