function Get-MrkNetworkDevice {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network Devices on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network Devices on a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkDevice -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/devices')
    return $request
}