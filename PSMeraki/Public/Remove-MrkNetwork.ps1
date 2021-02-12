function Remove-MrkNetwork {
    <#
    .SYNOPSIS
    Removes a new device, adds it to a network
    .DESCRIPTION
    blah
    .EXAMPLE
    Remove-MrkNetwork -networkId X_111122223639801111
    .PARAMETER networkId
    id of a network (get-MrkNetworks)[0].id
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    $request = Invoke-MrkRestMethod -Method DELETE -ResourceID ('/networks/' + $networkId)
    return $request
}