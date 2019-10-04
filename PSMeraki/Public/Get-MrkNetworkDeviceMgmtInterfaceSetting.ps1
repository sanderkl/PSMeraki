Function Get-MrkNetworkDeviceMgmtInterfaceSetting {
    <#
    .SYNOPSIS
    Retrieves the management interface settings for a device 
    .DESCRIPTION
    Retrieves the management interface settings for a device based on the provided networkId and device serialnumber
    .EXAMPLE
    Get-MrkNetworkDeviceMgmtInterfaceSetting -networkId X_112233445566778899 -Serial Q2PN-AB12-V3X6
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
    
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/devices/' + $serial + '/managementInterfaceSettings')
    return $request

}