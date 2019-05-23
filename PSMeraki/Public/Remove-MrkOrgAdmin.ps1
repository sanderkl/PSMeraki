function Remove-MrkOrgAdmin {
    <#
    .SYNOPSIS
    Deletes a dashboard Admin 
    .DESCRIPTION
    .EXAMPLE
    Remove-MrkOrgAdmin -adminId 6811694436398
    .PARAMETER orgId 
    defaults to Get-MrkFirstOrgID, for admins who maintain multiple organizations, OrgID can be specified
    .PARAMETER adminId 
    Admin id, to find it use get-mrkorgadmin
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$adminId
    )
    $request = Invoke-MrkRestMethod -Method DELETE -ResourceID ('/organizations/' + $orgId + '/admins/' + $adminId)
    return $request
}