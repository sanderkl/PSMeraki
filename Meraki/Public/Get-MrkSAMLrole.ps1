function Get-MrkSAMLrole {
    <#
    .SYNOPSIS
    Retrieves all SAML roles for a Meraki Organization
    .DESCRIPTION
    Gets a list of all SAML roles for a Meraki organization. 
    .EXAMPLE
    Get-MrkSAMLrole
    .EXAMPLE
    Get-MrkSAMLrole -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/samlRoles')
    return $request
}