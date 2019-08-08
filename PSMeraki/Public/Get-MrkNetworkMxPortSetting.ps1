function Get-MrkNetworkMxPortSetting{
    <#
    .SYNOPSIS
    Retrieves all MX Appliance Network VLAN settings for all ports or a specific port.
        {{baseUrl}}/networks/{networkId}/appliancePorts
        {{baseUrl}}/networks/{networkId}/appliancePorts/{appliancePortId}
    .DESCRIPTION
    Gets a list of all Meraki VLAN settings for all ports or a specific port for a given Meraki network. 
    .EXAMPLE
    Get-MrkNetworkMxPortSetting -networkId X_112233445566778899
    Get-MrkNetworkMxPortSetting -networkId X_112233445566778899 -portId
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter()][String]$portId
    )
    if($portId.Length -eq 0){
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/appliancePorts')
    }else{
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/appliancePorts/' + $portId)
    }
    return $request
}