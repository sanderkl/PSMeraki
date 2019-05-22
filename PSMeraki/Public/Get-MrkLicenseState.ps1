function Get-MrkLicenseState {
    <#
    .SYNOPSIS
    Retrieves Licence state for a Meraki Organization
    .EXAMPLE
    Get-MrkLicenseState
    .EXAMPLE
    Get-MrkLicenseState -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $orgId + '/licenseState')
    return $request
}