function Get-MrkDevice {
    <#
    .SYNOPSIS
    Retrieves the details of a Meraki device 
    .DESCRIPTION
    Retrieves the details of a Meraki device 
    .EXAMPLE
    Get-MrkDevice -networkId X_112233445566778899 -Serial Q2PN-AB12-V3X6
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER serial
    the serialnumber as mentioned on the Meraki device label.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter()][Alias("serialNr")][String]$serial
    )
    if($serial -eq ""){
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/devices')
    } else {
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/devices/' + $serial)
    }
    return $request
}