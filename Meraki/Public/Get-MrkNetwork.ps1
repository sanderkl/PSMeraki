function Get-MrkNetwork {
    <#
    .SYNOPSIS
    Retrieves all meraki networks for an organization
    .DESCRIPTION
    Describe the function in more detail
    .EXAMPLE
    Get-MrkNetwork 
    .EXAMPLE
    Get-MrkNetwork -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/networks')
    return $request
}