function Get-MrkOrganization {
    <#
    .SYNOPSIS
    Retrieves all Organizations the apikey has access to
    .EXAMPLE
    Get-MrkOrganization
    #>
    $request = Invoke-MrkRestMethod -Method GET -ResourceID '/organizations'
    return $request
}