Function Get-MrkInventory{
    <#
    .SYNOPSIS
    Returns the device-inventory of the organization
    .DESCRIPTION
    Returns the device-inventory of the organization
    {{baseUrl}}/organizations/{{organizationId}}/inventory
    .EXAMPLE
    Get-MrkInventory -organizationId 12345
    .PARAMETER orgId
    id of the organization. use Get-MrkFirstOrgID (or Get-MrkOrganization) to return the details of the organization your Api key has access to.
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID)
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/inventory"
    } Else { #mrkApiVersion v1
        Write-Host This API call is no longer supported in REST API version v1 -ForegroundColor Yellow
    }
}