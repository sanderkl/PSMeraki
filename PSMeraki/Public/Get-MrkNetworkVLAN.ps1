function Get-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network VLANs on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network VLANs on a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkVLAN -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID,
        [parameter()]$id
    )

    if ($null -eq $id -or "" -eq $id){
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/vlans')
    }else{
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/vlans/' + $id)
    }
  
    return $request
}