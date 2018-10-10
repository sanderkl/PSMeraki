function Get-MrkDeviceGroupPolicy {
    <#
    .SYNOPSIS
    Return the group policy that is assigned to a device in the network
    .DESCRIPTION
    .EXAMPLE
    Get-MrkDeviceGroupPolicy -networkID X_112233445566778899 -ClientMac <mac adress syntax unknown> 
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    .PARAMETER clientMac
    specify a MAC Address from a meraki device.
    .NOTES
    this function is untested
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$clientMac
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/clients/' + $clientMac + '/policy?timespan=86400')
    return $request
}