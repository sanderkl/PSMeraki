function Add-MrkNetworkSyslogServer {
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
    .PARAMETER hostIP
    Parameter to specify the syslog server host (IP)
    .PARAMETER port
    Parameter to specify the syslog service port (UDP, default 514)
    .PARAMETER roles
    Parameter to specify the meraki events to send to the syslog server. Multivalue string-array.
    example: -roles "Security events", "Appliance event log"
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$networkId,
        [Parameter(Mandatory)][string]$hostIP,
        [Parameter(Mandatory)][string]$port,
        [Parameter(Mandatory)][string[]]$roles
    )

    $syslogServers = @(Get-MrkNetworkSyslogServer -networkId $networkId);

    $syslogServer = [PSCustomObject]@{
        host = $hostIP
        port = $port
        roles = $roles
    }
    $syslogServers += $syslogServer;

    $mrkConfigState = [PSCustomObject]@{
        servers = $syslogServers
    }

    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/syslogServers') -body $mrkConfigState ;
    return $request
}