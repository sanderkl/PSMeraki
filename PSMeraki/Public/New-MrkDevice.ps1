function New-MrkDevice {
    <#
    .SYNOPSIS
    Adds (claims) a new device, adds it to a network
    .DESCRIPTION
    blah 
    .EXAMPLE
    New-MrkDevice -Networkid X_111122223639801111 -Serial Q2XX-XXXX-XXXX
    .PARAMETER networkId 
    id of a network get one using: (Get-MrkNetwork).id
    .PARAMETER serial
    Serial number of the physical device that is added to the network.
    alias set as 'SerialNr' base on original restapi module
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][Alias("serialNr")][String]$serial
    )
    $body = @{
        "serial" = $serial
    }
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkId + '/devices/claim') -Body $body
    return $request
}