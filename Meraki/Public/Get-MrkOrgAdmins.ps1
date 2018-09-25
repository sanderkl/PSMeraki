function Get-MrkAdmins {
    <#
    .SYNOPSIS
    Retrieves all meraki admins for an organization
    .DESCRIPTION
    .EXAMPLE
    Get-MrkAdmins 
    .EXAMPLE
    Get-MrkAdmins -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/admins')
    return $request
}