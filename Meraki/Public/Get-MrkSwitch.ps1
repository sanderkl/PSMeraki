function Get-MrkSwitch {
    <#
    .SYNOPSIS
    Retrieves all meraki switches for a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki switches in a Meraki network. 
    .EXAMPLE
    Get-MrkSwitches 
    .EXAMPLE
    Get-MrkSwitches -networkID X_112233445566778899
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