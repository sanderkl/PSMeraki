function Get-MrkNetworkMXL7FwRule{
    <#
    .SYNOPSIS
    Retrieves all Meraki L7 Firewall for a given Meraki network.
    For MX series the firewall rules are retrieved per NetworkID.
        {{baseUrl}}/networks/{networkId}/l7FirewallRules
    .DESCRIPTION
    Gets a list of all Meraki L7 Firewall for a given Meraki network. 
    .EXAMPLE
    Get-MrkNetworkMXL7FwRule -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/l7FirewallRules')
    return $request
}