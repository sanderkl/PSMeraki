function Get-MrkNetworkSyslogServer {
    <#
    .SYNOPSIS
    Retrieves the syslog server settings from the network
    .DESCRIPTION
    Retrieves the syslog server settings from the network
    .EXAMPLE
    Get-MrkNetworkMrkNetworkSyslogServer -networkId 
    .PARAMETER networkId
    Parameter to specify a specific networkId. This function-call for example used to dynamically retrieve a specific
    network and then use the retrieved id to get settings from that specific network like vlans and vlan enabled status
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/syslogServers');
    return $request
}