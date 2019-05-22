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
        [Parameter()][string]$address,
        [Parameter()][String]$tag,
        [Parameter()][String]$lat,
        [Parameter()][String]$lng
    )

    #retrieve current settings from the device and populate $body 
    $deviceProps = Get-MrkDevice -networkID $NetworkId -Serial $SerialNr;
    Write-Host current settings:
    $deviceProps
    if ("" -eq $devicename){$devicename = $deviceProps.name};
    if ("" -eq $address){$address = $deviceProps.address};
    if ("" -eq $tag){$tag = $deviceProps.tags};
    if ("" -eq $lat){$lat = $deviceProps.lat};
    if ("" -eq $lng){$lng = $deviceProps.lng};

    $body = @{
        "name"=$devicename
        "tags"=$tag
        "lat"=$lat
        "lng"=$lng
        "address"=$address
        "moveMapMarker"=$MoveMapMarker
    }

    convertto-json ($body)

    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $NetworkId + '/devices/' + $SerialNr) -Body $body  
    return $request
}