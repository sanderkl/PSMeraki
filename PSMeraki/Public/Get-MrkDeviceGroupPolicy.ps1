function Get-MrkDeviceGroupPolicy {
    <#
    .SYNOPSIS
    Return the group policy that is assigned to a device in the network
    .DESCRIPTION
    .EXAMPLE
    Get-MrkDeviceGroupPolicy -networkId X_112233445566778899 -ClientMac <mac adress syntax unknown>
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER clientMac
    specify a MAC Address from a meraki device.
    .NOTES
    this function is untested
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$clientMac
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/clients/' + $clientMac + '/policy?timespan=86400')
    return $request
}