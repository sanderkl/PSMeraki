function Update-MrkNetworkMxPortSetting{
    <#
    .SYNOPSIS
    Update an MX Appliance Network VLAN settings for a specific port.
        PUT {{baseUrl}}/networks/{networkId}/appliancePorts/{appliancePortId}
    .DESCRIPTION
    Update an MX Appliance Network VLAN settings for a specific port.
    .EXAMPLE
    Update-MrkNetworkMxPortSetting -networkId X_112233445566778899 -portId 3
    Update-MrkNetworkMxPortSetting -networkId X_112233445566778899 -portId 3
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER portId
    the appiance port id starting from 3. the number of available ports depends on the appliance type.
    the port 1 and 2 are the WAN ports.
    .PARAMETER enabled
    The status of the port
    .PARAMETER dropUntaggedTraffic
    Trunk port can Drop all Untagged traffic. When true, no VLAN is required. Access ports cannot have dropUntaggedTraffic set to true.
    .PARAMETER type
    The type of the port: 'access' or 'trunk'.
    .PARAMETER vlan
    Native VLAN when the port is in Trunk mode. Access VLAN when the port is in Access mode.
    .PARAMETER allowedVlans
    Comma-delimited list of the VLAN ID's allowed on the port, or 'all' to permit all VLAN's on the port
    .PARAMETER accessPolicy
    The name of the policy. Only applicable to Access ports.
    Valid values are: 'open', '8021x-radius', 'mac-radius', 'hybris-radius' for MX64 or Z3 or 
    any MX supporting the per port authentication feature. 
    Otherwise, 'open' is the only valid value and 'open' is the default value if the field is missing.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId,
        [Parameter()][String]$portId,
        [Parameter()][String][ValidateSet('true', 'false')]$enabled="false",
        [Parameter()][String][ValidateSet('true', 'false')]$dropUntaggedTraffic="false",
        [Parameter()][String][ValidateSet('trunk','access')]$type="trunk",
        [Parameter()][String]$vlan="1",
        [Parameter()][String[]]$allowedVlans="all",
        [Parameter()][String][ValidateSet('open','8021x-radius','mac-radius','hybris-radius')]$accessPolicy="open"
    )

    $PSBoundParameters
    #ensure dropUntaggedTraffic is false when type is set tot access.
    if ($type -eq 'access'){$dropUntaggedTraffic = "false"}

    $body = New-Object -TypeName PSObject -Property @{
        enabled = $enabled
        dropUntaggedTraffic = $dropUntaggedTraffic
        type = $type
        vlan = $vlan
    }
    #if the type is access, only then the accessPolicy value is valid. Default policy is assumed to be open so only adding the property accessPolicy to the request-body if it differs from open
    if ($type -eq 'access' -and $accessPolicy -ne 'open'){
        $body | Add-Member -MemberType NoteProperty -Name 'accessPolicy' -Value $accessPolicy
    }
    if ($type -eq 'trunk'){
        $body | Add-Member -MemberType NoteProperty -Name 'allowedVlans' -Value ($allowedVlans -join ",")
    }

    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/appliancePorts/' + $portId) -Body $body
    return $request
}