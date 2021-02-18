function Update-MrkDevice {
    <#
    .SYNOPSIS
    Updates a Meraki device
    .DESCRIPTION
    Updates properties for an already added Meraki device
    .EXAMPLE
    Update-MrkDevice -networkId X_111122223639801111 -serial Q2XX-XXXX-XXXX -NewName TestName -NewTags TestTag -NewAddress "Kalverstraat, Amsterdam"
    .PARAMETER networkId
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER serial
    Serial number of the physical device that is added to the network.
    .PARAMETER NewName
    Updates the new name for the meraki device
    .PARAMETER NewTags
    Updates the new tags for the meraki device
    .PARAMETER NewAddress
    Updates the new address for the meraki device
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][Alias("serialNr")][String]$serial,
        [Parameter()][String]$NewName,
        [Parameter()][String]$NewTags,
        [Parameter()][String]$NewAddress
    )
    $body = @{
        "name"=$NewName
        "tags"=$NewTags
        "address"=$NewAddress
    }
    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/devices/' + $serial) -Body $body
    return $request
}
