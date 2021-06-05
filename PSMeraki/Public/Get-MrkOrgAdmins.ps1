function Get-MrkOrgAdmins {
    <#
    .SYNOPSIS
    Retrieves all meraki admins for an organization
    .DESCRIPTION
    .EXAMPLE
    Get-MrkOrgAdmins
    .EXAMPLE
    Get-MrkOrgAdmins -OrgId 111222
    .PARAMETER orgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID)
    )
    Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/admins"
}