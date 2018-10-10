function Remove-MrkOrgAdmin {
    <#
    .SYNOPSIS
    Deletes a dashboard Admin 
    .DESCRIPTION
    .EXAMPLE
    Remove-MrkOrgAdmin -AdminId 6811694436398
    .PARAMETER OrgId 
    defaults to Get-MrkFirstOrgID, for admins who maintain multiple organizations, OrgID can be specified
    .PARAMETER AdminId 
    Admin id, to find it use get-mrkorgadmin
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$AdminId
    )
    $request = Invoke-MrkRestMethod -Method DELETE -ResourceID ('/organizations/' + $OrgId + '/admins/' + $AdminId)
    return $request
}