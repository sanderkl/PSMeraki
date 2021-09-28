function Get-MrkLicenses {
    <#
    .SYNOPSIS
    Retrieves license info for a Meraki organization
    .EXAMPLE
    Get-MrkLicenses
    .EXAMPLE
    Get-MrkLicenses -OrgId 111222
    .EXAMPLE
    Get-MrkLicenses -OrgId 111222 -LicenseID
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    .PARAMETER LicenseID
    optional parameter specify a LicenseID, default it will return all licenses associated with this org
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID),
        [Parameter()][String]$licenseID
    )
    if ($licenseID) {
        if ($mrkApiVersion -eq 'v0'){
            Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/licenses/$licenseID"
        } else { #mrkApiVersion v1
            Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/licenses/$licenseID"
        }
    } else {
        if ($mrkApiVersion -eq 'v0'){
            Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/licenses"
        } else { #mrkApiVersion v1
            Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/licenses"
        }
    }
}