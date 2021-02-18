function Get-MrkNetworkMXL3FwRule {
    <#
    .SYNOPSIS
    Retrieves Meraki L3 Firewall rules for a given Meraki network.
    .DESCRIPTION
    Gets a list of all Meraki L3 Firewall rule for a given Meraki network.
    For MX series the firewall rules are retrieved per networkId.
        {{baseUrl}}/networks/{{networkId}}/l3FirewallRules
    .EXAMPLE
    Get-MrkNetworkMXL3FwRule -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetwork [-orgId]
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/l3FirewallRules')
    return $request
}