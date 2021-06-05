function Get-MrkTemplateNetworks {
    <#
    .SYNOPSIS
    Retrieves all meraki networks with either a bound Template or a matching template ID
    .DESCRIPTION
    Retrieves all meraki networks for an organization bound to a template or a single template if the templateId is provided
    .EXAMPLE
    Get-MrkTemplateNetworks
    .EXAMPLE
    Get-MrkTemplateNetworks -OrgId 111222
    .EXAMPLE
    Get-MrkTemplateNetworks -templateId L_615304299089509767
    .PARAMETER orgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    .PARAMETER TemplateId
    optional parameter to specify a specific configTemplateID. retrieve a specific set of networks bound to a template, use get-mrkTemplate
    and then use the retrieved id to get networks from that specific template
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID),
        [Parameter()][String]$templateId
    )
    if(!$templateId){
        #{{baseUrl}}/organizations/{{organizationId}}/networks
        Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/networks" | Where-Object {$null -ne $_.configTemplateID}
    } else {
        #{{baseUrl}}/organizations/{{organizationId}}/networks?configTemplateId={{templateId}}
        Invoke-MrkRestMethod -Method GET -ResourceID "/organizations/$orgId/networks?configTemplateId=$templateId"
    }
}