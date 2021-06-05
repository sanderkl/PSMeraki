function Get-MrkOrganization {
    <#
    .SYNOPSIS
    Retrieves all Organizations the apikey has access to
    .EXAMPLE
    Get-MrkOrganization
    #>
    [CmdletBinding()]
    Param ()
    Write-Verbose "Get-MrkOrganization: called"
    Invoke-MrkRestMethod -Method GET -ResourceID "/organizations"
}