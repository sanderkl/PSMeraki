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
    .PARAMETER devicename
    Optional parameter to specify the name of the device
    .PARAMETER address
    Optional parameter to specify the address of the device
    .PARAMETER tag
    Optional parameter to specify the tag(s) to identify the device
    .PARAMETER lat
    Optional parameter to specify the latitude value of the device
    .PARAMETER lng
    Optional parameter to specify the longitude value of the device
	.PARAMETER notes
	Optional parameter to specify notes on the device, max 255 char
	.PARAMETER movemapmarker
	Optional parameter to set the move map marker flag if you use an address instead of a lat/lng. If True, will ignore lat/lng parameters
    .NOTES
    2do: parameter 'networkId' should mandatory for a parameter set aimed at the v0 version

    #>
    
    [CmdletBinding()]
    Param (
        [Parameter()][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][Alias("serialNr")][String]$serial,
        [Parameter()][ValidateNotNullOrEmpty()][String]$devicename,
        [Parameter()][string]$address,
        [Parameter()][String]$tag,
        [Parameter()][String]$lat,
        [Parameter()][String]$lng,
        [Parameter()][String]$notes,
        [Parameter()][Switch]$movemapmarker
    )

    #retrieve current settings from the device and populate $body
    $deviceProps = Get-MrkDevice -networkID $networkId -Serial $serial
    if (!$devicename){$devicename = $deviceProps.name}
    if (!$address){$address = $deviceProps.address}
    if (!$tag){$tag = $deviceProps.tags}
    if (!$lat){$lat = $deviceProps.lat}
    if (!$lng){$lng = $deviceProps.lng}
    if (!$notes){$notes = $deviceProps.notes}

    $body = @{
        "name"=$devicename
        "tags"=$tag
        "lat"=$lat
        "lng"=$lng
        "address"=$address
        "notes" = $notes
    }
    if ($movemapmarker) {$body.Remove('lat');$body.Remove('lng');$body.Add("moveMapMarker",$true)}
    convertto-json ($body)

    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method PUT -ResourceID "/networks/$networkId/devices/$serial" -Body $body
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method PUT -ResourceID "/devices/$serial" -Body $body
    }
}