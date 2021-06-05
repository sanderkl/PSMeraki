function Get-MrkNetworkDevice {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network Devices on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network Devices on a Meraki network.
    .EXAMPLE
    Get-MrkNetworkDevice -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/devices"
}