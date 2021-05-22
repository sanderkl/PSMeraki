function Get-MrkOrganization {
    <#
    .SYNOPSIS
    Retrieves all Organizations the apikey has access to
    .EXAMPLE
    Get-MrkOrganization
    #>
    [CmdletBinding()]
    Param ()
    $response = Invoke-MrkRestMethod -Method GET -ResourceID '/organizations'
    return $response
}