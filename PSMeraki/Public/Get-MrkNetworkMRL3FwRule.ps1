function Get-MrkNetworkMRL3FwRule {
    <#
    .SYNOPSIS
    Retrieves all Meraki MR-series L3 Firewall for a given Meraki network/ssid.
    .DESCRIPTION
    Gets a list of all Meraki L3 Firewall for a given Meraki network/ssid depending on the device-series. 
    For MR series the firewall rules are retrieved per SSID-id per NetworkID. The SSID number is an integer 0 to 14.
    Each SSID number has a unique SSID-name and settings like enabled, psk, etc etc
        {{baseUrl}}/networks/{{networkId}}/ssids/{{ssidNum}}]/l3FirewallRules
    .EXAMPLE
    Get-MrkNetworkMRL3FwRule -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId. Find a networkId using get-MrkNetwork [-orgId]
    .PARAMETER ssidId
    specify the SSID number (0-14). Find the SSIDs with Get-MrkNetworkSSID
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("id")] 
        [String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$ssidId
    )
    begin{}
    process{
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/ssids/' + $ssidId + '/l3FirewallRules')
        return $request
    }
    end{}
}