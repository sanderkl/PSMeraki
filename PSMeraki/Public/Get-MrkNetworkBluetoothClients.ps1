function Get-MrkNetworkBluetoothClients {
    <#
    .SYNOPSIS
    Retrieves all bluetooth clients on a Meraki network
    .DESCRIPTION
    .EXAMPLE
    Get-MrkNetworkDevice -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, to find one use get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/bluetoothClients')
    return $request
}