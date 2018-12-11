function Update-MrkOrgAdmin {
    <#
    .SYNOPSIS
    Updates an existing dashboard Administrator
    .DESCRIPTION
    .EXAMPLE

    Update-MrkOrgAdmin -email 'piets@Test.com' -orgAccess 'read-only'
    grants read-only access on everyting on your dashboard.

    Update-MrkOrgAdmin -email 'piets@Test.com' -tag 'YOURTAG' -tagaccess 'Full'
    Grants access to all objects tagged YOURTAG

    .PARAMETER OrgId 
    defaults to Get-MrkFirstOrgID, for admins who maintain multiple organizations, OrgID can be specified
    .PARAMETER email
    email address of the dashboard admin 
    .PARAMETER orgAccess
    Access for the admin either 'full' 'read-only' or 'none'. If its 'none' tags specify the permissions. 
    .PARAMETER tag
    The tag of the objects you want to change access on.
    .PARAMETER tagaccess
    Access for the admin either 'full' 'read-only' or 'none' on the obects specified in tag.
    .NOTES

    #>
    [CmdletBinding()]
    
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        #[Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter()][ValidateNotNullOrEmpty()][String]$email,
        [Parameter()][ValidateSet('full','read-only','none')][String]$orgAccess,
        [Parameter()][ValidateNotNullOrEmpty()][String]$tag,
        [Parameter()][ValidateSet('full','read-only','none')][String]$tagAccess
    )

    
 $tags=@([pscustomobject]@{tag = $tag; access = $tagaccess})
 $networks=

    
    $global:body  = @{
        "email" = $email
        "Orgaccess" = $orgAccess
        "tags" =   $tags
    }



    $id= get-mrkorgadmins -OrgId $Orgid |where{$_.email -like $email}
    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/organizations/' + $OrgId + '/admins/'+ $id.id ) -Body $body  
    return $request
}







