function New-MrkDevice {
    <#
    .SYNOPSIS
    Adds (claims) a new device, adds it to a network
    .DESCRIPTION
    blah 
    .EXAMPLE
    New-MrkDevice -Networkid X_111122223639801111 -Serial Q2XX-XXXX-XXXX
    .PARAMETER NetworkId 
    id of a network get one using: (Get-MrkNetwork).id
    .PARAMETER SerialNr 
    Serial number of the physical device that is added to the network. 
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