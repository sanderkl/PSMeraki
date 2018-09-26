function Update-MrkOrgAdmin {
    <#
    .SYNOPSIS
    Creates new dashboard Admin 
    .DESCRIPTION
    .EXAMPLE
    Update-MrkOrgAdmin -AdminId 681169443639837138 -Name 'Piet Test2' -email 'piet2@Test.com' -orgAccess 'read-only'
    .PARAMETER OrgId 
    defaults to Get-MrkFirstOrgID, for admins who maintain multiple organizations, OrgID can be specified
    .PARAMETER Name
    Name of the dashboard admin 
    .PARAMETER email
    email address of the dashboard admin 
    .PARAMETER orgAccess
    Access for the admin either 'full' 'read-only' or 'none'. If its 'none' tags specify the permissions. 
    .PARAMETER tags
    see rest api diucs for details.
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$AdminId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$email,
        [Parameter(Mandatory)][ValidateSet('full','read-only','none')][String]$orgAccess,
        [Parameter()][ValidateNotNullOrEmpty()][String]$tags
    )
    $body  = @{
        "name" = $Name
        "email" = $email
        "orgAccess" = $orgAccess
        "Tags" = $tags
    }
    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/organizations/' + $OrgId + '/admins/' + $AdminId) -Body $body  
    return $request
}