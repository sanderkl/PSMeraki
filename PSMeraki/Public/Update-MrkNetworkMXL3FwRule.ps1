function Update-MrkNetworkMXL3FwRule {
    <#
    .SYNOPSIS
        Retrieves all Meraki L3 Firewall for a given Meraki network/ssid.
        Adds the newly provided rule to the top of the list.
    .DESCRIPTION
        Retrieves all Meraki L3 Firewall for a given Meraki network/ssid.
        Adds the newly provided rule to the top of the list.
    .EXAMPLE
        Update-MrkNetworkMXL3FwRule -networkId X_112233445566778899 -comment 'deny clientaccess' -policy 'deny' -protocol 'any' -srcPort 'any' -srcCidr '10.20.30.0/24' -destPort 'any' -destCidr '10.20.20.0/24' -action add
    .PARAMETER networkId
        specify a networkId, find an id using get-MrkNetworks
    .PARAMETER comment
        specify the rule comment to describe the rule purpose
    .PARAMETER policy
        specify 'deny' or 'allow'
    .PARAMETER protocol
        specify the protocol 'any', 'tcp' or 'udp'
    .PARAMETER srcPort
        specift 'any', a single port like '53', or a port-range like '21-23'.
        comma-separated values are supported too if the protocol is not tcp OR udp (not any).
    .PARAMETER srcCidr
        specify the destination network by IP address or CIDR notation
        e.g: 10.0.5.0/24
        e.g: 192.168.1.50, 192.168.1.50/32
    .PARAMETER destPort
        specift 'any', a single port like '53', or a port-range like '21-23'.
        comma-separated values are supported too if the protocol is not tcp OR udp (not any).
    .PARAMETER destCidr
        specify the destination network by IP address or CIDR notation
        e.g: 10.0.5.0/24
        e.g: 192.168.1.50, 192.168.1.50/32
    .PARAMETER action
        specify 'add' or 'remove'
        Add will add the rule as new topmost entry.
        Remove will find the rule specified by the unique combination of protocol,destport and destCidr or comment.
        Add will also simply commit the provided ruleSetState object if no other parameters are provided
    .PARAMETER reset
        optional switch to determine if the cmdlet will keep the existing L3 Firewall rules or start with a clean set of rules and add only this new one.
        not specifying it or assigning $false will keep the existing rules (default).
    .PARAMETER commit
        optional parameter to specify if you want to commit the change immediately or only add or remove the rule in the GLOBAL rulebase variable $global:MXL3RuleSetState.
        This variable $global:MXL3RuleSetState is retrieved from the network unless the RESET switch is provided and that $global:MXL3RuleSetState is used to add/remove rules.
        After each add/remove iteration the $global:MXL3RuleSetState is updated and once you provide the commit swith that leads to the API call to meraki.
    .PARAMETER RuleSetState
        optional parameter to provide the ruleset to work with. When provided without any other rule remove/add action you apply the set as provided.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$networkId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$comment,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("allow", "deny")]
        [String]$policy,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("any","tcp","udp","icmp")]
        [String]$protocol,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$srcPort,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$srcCidr,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$destPort,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$destCidr,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("add", "remove", "set")]
        [String]$action,

        [Parameter()]
        $RuleSetState,

        [Parameter()]
        [switch]$reset,

        [Parameter()]
        [switch]$commit
    )

    $ruleset = @()
    if ($reset){
        #clear the $global:MXL3RuleSetState and optionally populate it with the provided RuleSetState
        $global:MXL3RuleSetState = @()
        if($RuleSetState){
            $global:MXL3RuleSetState = $RuleSetState
        }
    }
    else{
        if($RuleSetState) {
            #use the provided ruleset and store it into/overwrite the $global:MXL3RuleSetState
            $global:MXL3RuleSetState = $RuleSetState
        }
        elseif( $global:MXL3RuleSetState.count -gt 0 -and $global:MXNetworkId -eq $networkId ){
            #simply assume the $global:MXL3RuleSetState to be good as it is not empty and the global MXNetworkId equals the working id.
            #need to build in a validation
        }
        else {
            #not resetting and the current network is different from the previous run, or the $global:MXL3RuleSetState isn't initialized yet.
            #read the current L3 firewallrules into the global $global:MXL3RuleSetState and set the $global:MXNetworkId to this network id.
            #This makes the $global:MXL3RuleSetState usable for the next iteration if the $RuleSetState and $reset are not provided.
            $ruleset = Get-MrkNetworkMXL3FwRule -networkId $networkId
            #the non-default rules are in the array above the default-rule which cannot be set. When retrieving the current rules to add to or remove from
            #strip the last/bottom rule and store the remaining set in $global:MXL3RuleSetState
            $global:MXL3RuleSetState = $ruleset[0..$(($ruleset.Count) -2)]
            $global:MXNetworkId = $networkId
        }
        #the non-default rules are in the array above the default-rule which cannot be set. When retrieving the current rules to add to or remove from
        #extract those custom rules from the array
        #$ruleset = $MXL3RuleSetState[0..$(($MXL3RuleSetState.Count) -2)]
    }
    
    #populate the to-be ruleset first with the existing rules (will be none in case of reset)
    $applyRules = @()
    ForEach ($rule in $global:MXL3RuleSetState){

        #if the action is delete and either the current rule comment matches the given comment, or the rule specifications protocol/destPort/destCidr are equal keep the entry in the ruleset. 
        if ($action -eq 'remove' -and `
          (($rule.protocol -eq $protocol -and `
            $rule.destPort -eq $destPort -and `
            $rule.destCidr -eq $destCidr) -or `
            ($rule.comment -eq $comment))){
                "No longer adding this rule: $comment";
                $rulePresent = $false;
                continue
            }

        if ($action -eq 'add' -and `
            (($rule.protocol -eq $protocol -and `
              $rule.srcPort -eq $srcPort -and `
              $rule.srcCidr -eq $srcCidr -and `
              $rule.destPort -eq $destPort -and `
              $rule.destCidr -eq $destCidr) -or `
              ($rule.comment -eq $comment))){
                  "Not adding this rule as it is already present: $comment";
                  $rulePresent = $true;
              }

        #add this exising rule to the $applyRules object
        $ruleEntry = New-Object -TypeName PSObject -Property @{
            comment  = $rule.comment
            policy   = $rule.policy
            protocol = $rule.protocol
            srcPort  = $rule.srcPort
            srcCidr  = $rule.srcCidr
            destPort = $rule.destPort
            destCidr = $rule.destCidr
        }

        $applyRules += $ruleEntry

    }

    #append the new ruleobject to the applyRules
    if ($action -eq 'add' -and $true -ne $rulePresent){
        $ruleEntry = New-Object -TypeName PSObject -Property @{
            comment  = $comment
            policy   = $policy
            protocol = $protocol
            srcPort  = $srcPort
            srcCidr  = $srcCidr
            destPort = $destPort
            destCidr = $destCidr
        }

        $applyRules += $ruleEntry
    };

    #the resulting $applyRules must be stored in the $global:MXL3RuleSetState
    $global:MXL3RuleSetState = $applyRules

    #construct the full ruleObject to push into the $body of the RESTapi request
    $ruleObject = New-Object -TypeName PSObject -Property @{
        rules = $applyRules
    }

    #if the rules have changed and you want to commit, or you want to commit a (saved) configuration apply the change now.
    if( ($true -ne $rulePresent -and $commit) -or $commit){

        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/l3FirewallRules') -body $ruleObject
        return $request

    }

}
