function Update-MrkDevice {
    <#
    .SYNOPSIS
    Adds (claims) a new device, adds it to a network
    .DESCRIPTION
    blah 
    .EXAMPLE
    Update-MrkDevice -Networkid X_111122223639801111 -SerialNr Q2XX-XXXX-XXXX -NewName TestName -NewTags TestTag -NewAddress "Kalverstraat, Amsterdam" 
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER SerialNr 
    Serial number of the physical device that is added to the network. 
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$SerialNr,
        [Parameter()][String]$NewName,
        [Parameter()][String]$NewTags,
        [Parameter()][String]$NewAddress
    )
    $body = @{
        "name"=$Name
        "tags"=$Tags
        "address"=$Address
    }
    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $Networkid + '/devices/' + $SerialNr) -Body $body  
    return $request
}