function Get-MrkFirstOrgID {
  <#
  .SYNOPSIS
  This function returns the first organization ID (a number) from the list that is produced by Get-MrkOrganizations
  .DESCRIPTION
  This Function is called if the organization is not specified for a function that requires an OrgId. in those functions it can be specified using parameter -OrgId. 
  for example function Get-MrkNetworks uses this fuinction to automatically get an OrgId 
  .EXAMPLE
  Get-MrkFirstOrgID
  #>
    $MrkOrg = Get-MrkOrganization
    if ($MrkOrg){
        return $MrkOrg[0].id
    } Else {
        Write-Output "no meraki organizations found is api correct? use Set-MrkRestApiKey `<key`>"
    }
}