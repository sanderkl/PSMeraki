Function Get-MrkNetworkMxCfRule{
    <#
    .SYNOPSIS
    Retrieves all Meraki MX ContentFiltering rules for a given Meraki network Id.
    MX series ContentFiltering rules are retrieved per NetworkID.
    .DESCRIPTION
    Gets a list of all Meraki L3 ContentFiltering rules for a given Meraki network.
    .EXAMPLE
    Get-MrkNetworkMxCfRule -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using Get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/ContentFiltering"
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/appliance/contentFiltering"
    }   
}