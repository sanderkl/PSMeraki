function Get-MrkDeviceClient {
    <#
    .SYNOPSIS
    Retrieves all clients connected to a Meraki device, in the last month
    .DESCRIPTION
    Gets a list of all Clients connected to a Meraki device, connected in the last month.
    .EXAMPLE
    Get-MrkDeviceClient -Serial Q2XX-XXXX-XXXX
    .PARAMETER Serial
    specify a DeviceSerial, find a serial number using Get-MrkNetworkDevices
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Serial
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/devices/' + $Serial + '/clients?timespan=84000')
    return $request
}