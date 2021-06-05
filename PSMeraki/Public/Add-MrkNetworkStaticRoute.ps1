Function Add-MrkNetworkStaticRoute{
    <#
    .SYNOPSIS
    Adds a Static Route to a Meraki network
    .DESCRIPTION
    Adds a Static Route to a Meraki network, identifying the network with the Network ID, to find an id use get-MrkNetwork
    .EXAMPLE
    Add-MrkNetworkStaticRoute -networkId X_111122223639801111 -name "vesselid-Client" -subnet 192.168.160.0/24 -gatewayIp 192.168.0.253 -enabled $true
    .PARAMETER networkId
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER Name
    The Name of the new static route
    .PARAMETER subnet
    The subnet of the static route
    .PARAMETER gatewayIp
    The remote next-hop IP for the static route
    .PARAMETER enabled
    hardcoded value that enables this VLAN
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$name,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$subnet,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$gatewayIp,
        [Parameter()][ValidateNotNullOrEmpty()][boolean]$enabled=$true
    )
    $body  = @{
        "name" = $name
        "subnet" = $subnet
        "gatewayIp" = $gatewayIp
        "enabled" = $enabled
    }

    #get the current list of Static routes
    $existingSRs = Get-MrkNetworkStaticRoute -networkId $networkId
    #in case a route already exists but needs to be updated initialize the [bool]$updateRoute. true/false determines the invoke PUT or POST
    [bool]$updateRoute = $false
    foreach ($sr in $existingSRs){
        if($sr.subnet -match $subnet){
            $updateRoute = $true
            $srId = $sr.id
        }
    }
    if ($mrkApiVersion -eq 'v0'){
        If($updateRoute){
            Invoke-MrkRestMethod -Method PUT -ResourceID "/networks/$networkId/staticRoutes/$srId" -Body $body
        }else{
            Invoke-MrkRestMethod -Method POST -ResourceID "/networks/$networkId/staticRoutes" -Body $body
        }
    } Else { #$mrkApiVersion v1
        If($updateRoute){
            Invoke-MrkRestMethod -Method PUT -ResourceID "/networks/$networkId/appliance/staticRoutes/$srId" -Body $body
        }else{
            Invoke-MrkRestMethod -Method POST -ResourceID "/networks/$networkId/appliance/staticRoutes" -Body $body
        }
    }
}