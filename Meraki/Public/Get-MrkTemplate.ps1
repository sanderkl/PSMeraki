function Get-MrkTemplate {
    <#
    .SYNOPSIS
    Retrieves all Meraki templates for an organization
    .DESCRIPTION
    Gets a list of all Meraki templates configured in an organization. 
    .EXAMPLE
    Get-MrkTemplate 
    .EXAMPLE
    Get-MrkTemplate -OrgId 111222
    .PARAMETER OrgId
    optional specify a org Id, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/configTemplates')
    return $request
}