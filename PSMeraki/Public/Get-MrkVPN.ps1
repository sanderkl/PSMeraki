function Get-MrkVPN {
    <#
    .SYNOPSIS
    Retrieves all VPNs for a Meraki Organization
    .DESCRIPTION
    Gets a list of all VPNs for a Meraki organization.
    .EXAMPLE
    Get-MrkVPN
    .EXAMPLE
    Get-MrkVPN -orgId 111222
    .PARAMETER orgId
    optional parameter specify an orgId, default it will take the first orgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID)
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/thirdPartyVPNPeers"
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/appliance/vpn/thirdPartyVPNPeers"
    }
}