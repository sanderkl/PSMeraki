Function Get-MrkInventory{
    <#
    .SYNOPSIS
    Returns the device-inventory of the organization
    .DESCRIPTION
    Returns the device-inventory of the organization
    {{baseUrl}}/organizations/{{organizationId}}/inventory
    .EXAMPLE
    Get-MrkInventory -organizationId 12345
    .PARAMETER organizationId 
    id of the organization. use Get-MrkOrganization to return the details of the organization your Api key has access to.
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][ValidateNotNullOrEmpty()][String]$organizationId=(Get-MrkOrganization).id
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $organizationId + '/inventory')
    
    return $request
}