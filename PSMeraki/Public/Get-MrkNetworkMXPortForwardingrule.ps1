function Get-MrkNetworkMXPortForwardingrule {
    <#
    .SYNOPSIS
    Retrieve the configured port forwarding rules as set for the MX based network.
    .DESCRIPTION
    Retrieve the configured port forwarding rules as set for the MX based network.
    .EXAMPLE
    Get-MrkNetworkMXPortForwardingrule -networkId L_112233445566778899
    Response
    Successful HTTP Status: 200

    {
    "rules": [
        {
        "lanIp": "192.168.128.1",
        "allowedIps": [
            "any"
        ],
        "name": "Description of Port Forwarding Rule",
        "protocol": "tcp",
        "publicPort": "8100-8101",
        "localPort": "442-443",
        "uplink": "both"
        }
    ]
    }
    .PARAMETER networkId
    parameter to specify a specific networkId.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][string]$networkId
    )


    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/portForwardingRules') ;

    return $request
}