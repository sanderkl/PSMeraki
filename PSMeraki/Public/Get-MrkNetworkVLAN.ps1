function Get-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network VLANs on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network VLANs on a Meraki network.
    .EXAMPLE
    Get-MrkNetworkVLAN -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER id
    specify a vlan by id. the id is the actual vlan number like 1, 400, 410, etc
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [parameter()][string]$id
    )
    if ($mrkApiVersion -eq 'v0'){
        if ($null -eq $id -or "" -eq $id){
            Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/vlans"
        }else{
            Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/vlans/$id"
        }
    } Else { #mrkApiVersion v1
        if ($null -eq $id -or "" -eq $id){
            Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/appliance/vlans"
        }else{
            Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/appliance/vlans/$id"
        }
    }    
}