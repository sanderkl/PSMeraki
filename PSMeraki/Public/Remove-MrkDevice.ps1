function Remove-MrkDevice {
    <#
    .SYNOPSIS
    Removes a new device, adds it to a network
    .DESCRIPTION
    blah 
    .EXAMPLE
    Remove-MrkDevice -Networkid X_111122223639801111 -Serial Q2XX-XXXX-XXXX
    .PARAMETER networkId 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER serial 
    Serial number of the physical device that is added to the network. 
    alias set as 'SerialNr' base on original restapi module
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][Alias("serialNr")][String]$serial
    )
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkId + '/devices/' + $serial + '/remove')
    return $request
}