Function Get-MrkNetworkDevicePerformance {
    <#
    .SYNOPSIS
    Retrieves the device LOAD of an MX appliance in the given network. 
    .DESCRIPTION
    Retrieves the device LOAD of an MX appliance in the given network based on the networkid and serialnumber provided.
    It only works for MX devices.
    .EXAMPLE
    Get-MrkNetworkDevicePerformance -networkId X_112233445566778899 -Serial Q2PN-AB12-V3X6
    Result:
    perfScore
    ---------
        7

    The returned number is a value between 0 and 100 indicating the device utilization.
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER serial
    the serialnumber as mentioned on the Meraki device label.
    #>

    #GET/networks/{networkId}/devices/{serial}/managementInterfaceSettings
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId,
        [Parameter(Mandatory)][Alias("serialNr")][string]$serial
    )
    
    $mrkDeviceModel = (Get-MrkNetworkDevice -networkId $networkId | Where-Object {$_.serial -eq $serial -and $_.model -match 'MX'})
    if($mrkDeviceModel){
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/devices/' + $serial + '/performance')
        return $request
    }else{
        write-host "Device with serial $serial is not an MX model or not found in the network $networkId"
    }
}
