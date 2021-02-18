function Remove-MrkNetworkTemplate {
    <#
    .SYNOPSIS
    Unbinds a device from a template
    .DESCRIPTION
    blah
    .EXAMPLE
    Remove-MrkNetworkTemplate -networkId X_111122223639801111
    .PARAMETER networkId
    id of a network (get-MrkNetworks)[0].id
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkId + '/unbind/')
    return $request
}