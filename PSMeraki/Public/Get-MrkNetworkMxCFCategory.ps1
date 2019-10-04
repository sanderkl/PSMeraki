Function Get-MrkNetworkMXCFCategory{
    <#
    .SYNOPSIS
    Retrieves all Meraki MX contentFiltering categories for a given Meraki network Id.
    .DESCRIPTION
    Retrieves all Meraki MX contentFiltering categories for a given Meraki network Id.
    .EXAMPLE
    Get-MrkNetworkMXCFCategory -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/contentFiltering/categories')
    return $request
    
}