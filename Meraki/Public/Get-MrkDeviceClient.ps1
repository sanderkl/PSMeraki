function Get-MrkDeviceClient {
    <#
    .SYNOPSIS
    Retrieves all clients connected to a Meraki device
    .DESCRIPTION
    Gets a list of all Clients connected to a Meraki device. 
    .EXAMPLE
    Get-MrkDeviceClient -DeviceSerial Q2XX-XXXX-XXXX
    .PARAMETER DeviceSerial
    specify a DeviceSerial, find a serial number using Get-MrkNetworkDevices
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$DeviceSerial
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/devices/' + $networkID + '/clients?timespan=84000')
    return $request
}