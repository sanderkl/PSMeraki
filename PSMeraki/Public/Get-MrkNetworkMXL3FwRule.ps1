function Get-MrkNetworkMXL3FwRule {
    <#
    .SYNOPSIS
    Retrieves Meraki L3 Firewall rules for a given Meraki network.
    .DESCRIPTION
    Gets a list of all Meraki L3 Firewall rules for a given Meraki network.
    MX series firewall rules are retrieved per networkId.
    {{baseUrl}}/networks/{{networkId}}/l3FirewallRules
    .EXAMPLE
    Get-MrkNetworkMXL3FwRule -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using Get-MrkNetwork [-orgId]
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/l3FirewallRules"
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/appliance/firewall/l3FirewallRules"
    }
}