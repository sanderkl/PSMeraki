function Remove-MrkNetworkVLAN { # UNTESTED
    <#
    .SYNOPSIS
    Removes a VLAN from a Meraki network
    .DESCRIPTION
    Removes a VLAN from a Meraki network, identifying the network with the Network ID, to find an id use Get-MrkNetwork
    .EXAMPLE
    Remove-MrkNetworkVLAN -networkId X_111122223639801111 -id 500
    .PARAMETER networkId
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER id
    VLAN is, a number between 1 and 4094
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$id
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method DELETE -ResourceID "/networks/$networkId/vlans/$id"
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method DELETE -ResourceID "/networks/$networkId/appliance/vlans/$id"
    }    
}