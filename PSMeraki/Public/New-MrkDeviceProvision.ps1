function New-MrkDeviceProvision {
        <#
    .SYNOPSIS
    Provisions a new device in a Meraki network. 
    .DESCRIPTION
    Provisions a client with a name and policy. Clients can be provisioned before they associate to the network.
    .EXAMPLE
    New-MrkDeviceProvision -networkId L_564638803281579210 -clientMac 0E:12:12:12:12:12 -clientName MyNewDevicaName
    .PARAMETER networkId 
    networkId is the identitfier for a network and can be found using get-mrknetwork.
    .PARAMETER clientMac 
    MAC address of the new client that will be provisioned.
    .PARAMETER clientName
    Name for the client that will be provisioned.
    .PARAMETER devicePolicy
    Group policy name that will be forced on the client. 
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$clientMac,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$clientName,
        [Parameter()][String]$devicePolicy
    )
    $body = @{
        "clients" =@(
            ([PSCustomObject]$clientbody =@{
            "mac" = $clientMac
            "name" = $clientName
            })
        )
    "devicePolicy" = $devicePolicy
    }
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkId + '/clients/provision') -Body $body
    return $request
}