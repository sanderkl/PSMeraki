function Get-MrkNetworkBluetoothClient {
    <#
    .SYNOPSIS
    Retrieves all bluetooth clients on a Meraki network
    .DESCRIPTION
    .EXAMPLE
    Get-MrkNetworkBluetoothClient -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, to find one use get-MrkNetworks
    .PARAMETER ClientID
    specify a ClientID, to find one use get-MrkNetworkBluetoothClients (?)
    .NOTES
    Thsi function is untested
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$ClientID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/bluetoothClients/' + $ClientID)
    return $request
}