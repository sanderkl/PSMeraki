function Add-MrkSAMLrole {
    <#
    .SYNOPSIS
    Add SAML Role
    .DESCRIPTION
    .EXAMPLE
    Add-MrkSAMLrole -OrgId 111222 -role 'CoolAdmin' -orgAccess 'read-only'
    .PARAMETER OrgId
    defaults to Get-MrkFirstOrgID, for admins who maintain multiple organizations, OrgID can be specified
    .PARAMETER role
    Name of the SAML role
    .PARAMETER orgAccess
    Access for the admin either 'full' 'read-only' or 'none'.
    .PARAMETER networkID
    Optional, specify the network ID to target specific networks.
    .PARAMETER networkAccess
    Optional, specify the access level for the networkID either 'full' 'read-only' 'guest-ambassador' or 'monitor-only'
    .PARAMETER tags
    see rest api diucs for details.
    .NOTES
    This function is untested
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Role,
        [Parameter(Mandatory)][ValidateSet('full','read-only','none')][String]$orgAccess,
        [Parameter()][ValidateNotNullOrEmpty()][String]$networkID,
        [Parameter()][ValidateSet('full','read-only','none')][String]$networkAccess,
        [Parameter()][ValidateNotNullOrEmpty()][String]$tags
    )
    $body  = @{
        "role" = $Role
        "orgAccess" = $orgAccess
        "Tags" = $tags
    }

    if ($networkID){
        $accessArray = @()
        $value = [pscustomobject]@{
            id = $networkID
            access = $networkAccess
        }
    }
    $accessArray += $value
    $body | Add-Member -MemberType NoteProperty -Name "networks" -Value $accessArray
       
    Invoke-MrkRestMethod -Method POST -ResourceID "/organizations/$orgId/samlRoles" -Body $body
}