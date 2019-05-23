function Get-MrkNetworkMXL7FwRule{
    <#
    .SYNOPSIS
    Retrieves all Meraki L7 Firewall for a given Meraki network.
    For MX series the firewall rules are retrieved per NetworkID.
        {{baseUrl}}/networks/{networkId}/l7FirewallRules
    .DESCRIPTION
    Gets a list of all Meraki L7 Firewall for a given Meraki network. 
    .EXAMPLE
    Get-MrkNetworkMXL7FwRule -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/l7FirewallRules')
    return $request
}