function Get-MrkNetworkMXTrafficShaping {
    <#
    .SYNOPSIS
    Function to retrieve the configured Traffic Shaping Rules configured for the MX based network.
    .DESCRIPTION
    Function to retrieve the configured Traffic Shaping Rules configured for the MX based network.
    .EXAMPLE
    Get-MrkNetworkMXTrafficShaping -networkId L_112233445566778899
    .PARAMETER networkId
    parameter to specify a specific networkId. E.g L_112233445566778899
    Retrieve a list of network id's using $mrkNw = Get-mrkNetwork and find the id you need.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][String]$networkId
    )


    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/trafficShaping') ;

    return $request
}