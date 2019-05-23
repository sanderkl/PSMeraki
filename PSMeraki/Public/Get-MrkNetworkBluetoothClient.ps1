function Get-MrkNetworkBluetoothClient {
    <#
    .SYNOPSIS
    Retrieves all bluetooth clients on a Meraki network
    .DESCRIPTION
    .EXAMPLE
    Get-MrkNetworkBluetoothClient -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, to find one use get-MrkNetworks
    .PARAMETER clientId
    specify a clientId, to find one use get-MrkNetworkBluetoothClients (?)
    .NOTES
    Thsi function is untested
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$clientId
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/bluetoothClients/' + $clientId)
    return $request
}