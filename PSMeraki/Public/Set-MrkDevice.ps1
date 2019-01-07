function Set-MrkDevice {
    <#
    .SYNOPSIS
    Sets the properties of the device
    .DESCRIPTION
    blah 
    .EXAMPLE
    Set-MrkDevice -Networkid X_111122223639801111 -Serial Q2XX-XXXX-XXXX -devicename my-device -tag thistag -lat 52.12 -lng 41.21 
    .PARAMETER NetworkId 
    id of a network get one using: (Get-MrkNetwork).id
    .PARAMETER SerialNr 
    Serial number of the physical device that is added to the network. 
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$NetworkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$SerialNr,
        [Parameter()][ValidateNotNullOrEmpty()][String]$devicename,
        [Parameter()][String]$tag,
        [Parameter()][String]$lat,
        [Parameter()][String]$lng
    )
    $body = @{
        "name"=$devicename
        "tags"=$tag
        "lat"=$lat
        "lng"=$lng
        "Address"=$address
        "moveMapMarker"=$MoveMapMarker

    }

    convertto-json ($body)

    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $NetworkId + '/devices/' + $SerialNr) -Body $body  
    return $request
}