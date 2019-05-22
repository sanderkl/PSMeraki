function Get-MrkNetworkMXL3FwRule {
    <#
    .SYNOPSIS
    Retrieves Meraki L3 Firewall rules for a given Meraki network.
    .DESCRIPTION
    Gets a list of all Meraki L3 Firewall rule for a given Meraki network. 
    For MX series the firewall rules are retrieved per NetworkID.
        {{baseUrl}}/networks/{{networkId}}/l3FirewallRules
    .EXAMPLE
    Get-MrkNetworkMXL3FirewallRule -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/l3FirewallRules')
    return $request
}