function Set-MrkDevice {
    <#
    .SYNOPSIS
    Sets the properties of the device
    .DESCRIPTION
    blah 
    .EXAMPLE
    Set-MrkDevice -networkId X_111122223639801111 -Serial Q2XX-XXXX-XXXX -devicename my-device -tag thistag -lat 52.12 -lng 41.21 
    .PARAMETER networkId 
    id of a network get one using: (Get-MrkNetwork).id
    .PARAMETER serial 
    Serial number of the physical device that is added to the network. 
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][Alias("serialNr")][String]$serial,
        [Parameter()][ValidateNotNullOrEmpty()][String]$devicename,
        [Parameter()][string]$address,
        [Parameter()][String]$tag,
        [Parameter()][String]$lat,
        [Parameter()][String]$lng
    )

    #retrieve current settings from the device and populate $body 
    $deviceProps = Get-MrkDevice -networkID $networkId -Serial $serial;
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

    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/devices/' + $serial) -Body $body  
    return $request
}