function Get-MrkNetworkSiteToSiteVPN {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network SiteToSiteVPNs on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network SiteToSiteVPNs on a Meraki network.
    .EXAMPLE
    Get-MrkNetworkSiteToSiteVPN -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    [alias("Get-MrkNetworkS2SVpn")]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/siteToSiteVpn"
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/appliance/vpn/siteToSiteVpn"
    }
}