function Update-MrkNetworkMRFwRule {
    <#
    .SYNOPSIS
    NOT YET FUNCTIONAL.. Under construction !!!!!!!

    .DESCRIPTION
    
    .EXAMPLE
    Update-MrkNetworkMRFwRule -networkID X_112233445566778899 -paramaterX <valueX> -paramaterY <valueY>
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks

    .PARAMETER comment 
    specify a comment like "enable access to service xyz"
    .PARAMETER policy
    specify "deny" or "allow"
    .PARAMETER protocol
    specify the protocol like "tcp,udp,any"
    .PARAMETER srcPort
    specify which source-ports are used "usually any" for clients accessing an application.
    .PARAMETER srcCidr
    specify the source network ip or range in CIDR notation e.g "192.168.1.0/24"
    .PARAMETER destPort
    specify the destination ports like "21,22,445,389,etc" as comma separated list
    .PARAMETER destCidr
    Specify the destination network ip or range in CIDR notation e.g "192.168.21.123/32"
    .PARAMETER syslogEnabled
    Specify if syslog is enabled like "true" or "false"

    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$ssidID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$comment,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$policy,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$srcPort,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$srcCidr,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$destPort,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$destCidr,
        [String]$syslogEnabled="false"
    )

    #get the existing rule excluding the default one:
    $ActiveRuleSet = Get-MrkNetworkMRL3FirewallRules -networkID $networkID -ssidID $ssidID -Verbose | Where-Object comment -NotLike "Default rule"
    " ==== current rules start ==== "
    $ActiveRuleSet;
    " ==== current rules end ==== "

    $body = [pscustomobject]@{
        "rules" = $(@{
            "comment" = $comment
            "policy" = $policy
            "protocol" = $protocol
            "srcPort" = $srcPort
            "srcCidr" = $srcCidr
            "destPort" = $destPort
            "destCidr" = $destCidr
            "syslogEnabled" = $syslogEnabled
            })
        }

    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkID + '/ssids/' + $ssidID + '/l3FirewallRules') -Body $body
    return $request
}
