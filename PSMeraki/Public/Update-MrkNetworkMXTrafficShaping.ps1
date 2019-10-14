function Update-MrkNetworkMXTrafficShaping {
    <#
    .SYNOPSIS
    Function to configure the MX network traffic shaping rules.
    .DESCRIPTION
    Function to configure the MX network traffic shaping rules.
    The perClientBandwidthSetting, perClientBandwidthLimitUp and perClientBandwidthLimitDown together form the Meraki configuration item 'perClientBandwidthLimits'.
    If either perClientBandwidthLimitUp or perClientBandwidthLimitDown is not specified and the perClientBandwidthSetting is 'custom',
        then these 2 properties are set to the same value (up/down limit equal).
    .EXAMPLE
    This function call will add a rule to a blanc (resetRules $true) ruleset for all traffic to port 22 to tag the traffic as highPriority and ignore networkwide bandwidth settings.
    Update-MrkNetworkMXTrafficShaping -networkId N_1234567890123456 -action addRule -resetRules $true -definitionType port -definitionValue 22 -perClientBandwidthSetting ignore -trafficPriority high
    .EXAMPLE
    This function call will add a ruledefinition to the first/only existing rule for all traffic to port 5900
    Update-MrkNetworkMXTrafficShaping -networkId $OTITNW.id -action addRuleDefinition -definitionType port -definitionValue 5900
    .EXAMPLE
    This function call will add a ruledefinition to the existing ruleId 2 for all traffic to iprange "10.24.0.0/16"
    Update-MrkNetworkMXTrafficShaping -networkId $OTITNW.id -action addRuleDefinition -ruleId 2 -definitionType ipRange -definitionValue "10.24.0.0/16"
    .PARAMETER networkId
    Parameter to specify a specific networkId.
    .PARAMETER action
    Either "addRule", "removeRule", "addRuleDefinition", "removeRuleDefinition", "changeGlobalSetting", "changeRuleSetting", "set"
    In Meraki Traffic Shaping you add/remove Rules that show as rule 1, rule 2, etc. Each of these shaping rules get the traffic priority and bandwidth and within each of these share-rules you
        add/remove the ruleEntries like hosts/ports/ips/applications.
    addRule: adds a new main shaping-rule and requires the definitionType, definitionValue.
    removeRule: removes the rule specified by ruleId. This is the rule# as shown in the dashboard of the MX network.
    updateRule: updates the rule specified by ruleId. based on the parameters provided to the functioncall the active/working rule is updated and the new, full ruleset is applied.
    set: simply set the configuration using the provided settings in $mrkConfigState.
    .PARAMETER ruleId
    The rule-id of the rule you want to add/remove a definition to. Must be present when updating an existing ruleset (add/remove a definition) and more than 1 priorization rules are present.
    .PARAMETER newRuleId
    The new rule-id you must assign the rule identified by ruleId. (not implemented yet)
    .PARAMETER definitionType
    either "application", "applicationCategory","host","port","ipRange" or "localNet"
    .PARAMETER definitionValue
    The parameter value assigned to the definitionType. Type values "host","port","ipRange" or "localNet" are provided as as simple sting value. For example "1.2.3.4/24" or "443" or "contoso.com"
    Type values "application" or "applicationCategory" values must be provided as hashtable. For example @{id="meraki:layer7/application/205";name="Advertising.com"}
    The available layer7 applications or categories can be retrieved from the cisco meraki API reference.
    .PARAMETER perClientBandwidthSetting
    Either "network default", "ignore" or "custom".
    .PARAMETER perClientBandwidthLimitUp
    Specifies the limit in kbps for egress traffic for perClientBandwidthSetting=custom. LimitUp in kbps. E.g 2048 for 2048 kbps (2Mbps)
    .PARAMETER perClientBandwidthLimitDown
    Specifies the limit in kbps for ingress traffic for perClientBandwidthSetting=custom. The perClientBandwidthSetting, perClientBandwidthLimitUp and perClientBandwidthLimitDown together form 
    the Meraki configuration item 'perClientBandwidthLimits'. If either perClientBandwidthLimitUp or perClientBandwidthLimitDown is not specified and the perClientBandwidthSetting
    is 'custom', then these 2 properties are set to the same value (up/down limit equal). LimitUp in kbps. E.g 2048 for 2048 kbps (2Mbps)
    .PARAMETER dscpTagValue
    A numeric index value to set the traffic classification. see the Meraki dashboard pull-down menu for the available values. Some examples:
    0 = CS0/DF, 8 = CS1, 16 = CS2, 24 = CS3, 32 = CS4, 40 = CS5, 48 = CS6, 56 = CS7
    ...
    .PARAMETER trafficPriority
    Either "high", "normal" or "low"
    .PARAMETER defaultRulesEnabled
    Default TRUE. This enables the default traffic shaping rules as defined per Meraki: 
    SIP (Voice)/All Advertising, All Software Updates, All Online Backups/WebEx,Skype/All Audio and Video
    .PARAMETER commit
    Switch to control whether to commit the current rule-state of if a subsequent function-call is to be executed to add/remove
    other rules or rule-entries.
    .PARAMETER mrkConfigState
    Parameter to pass an object that contains a complete configuration you need to apply or start working with.
    Usefull to reapply settings based on a saved configuration.
    .PARAMETER overRideNWid
    Optional parameter used in conjunction with parameter mrkConfigState to allow the provided mrkConfigState object to be applied to this network while
        the provided mrkConfigState settings were retrieved from another networkId.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][string]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()]
        [ValidateSet("addRule", "removeRule", "addRuleDefinition", "removeRuleDefinition", "changeGlobalSetting", "changeRuleSetting", "set")]
            [string]$action,
        [Parameter()]$ruleId,
        [Parameter()]$newRuleId,
        [Parameter()][ValidateSet("application", "applicationCategory","host","port","ipRange","localNet")][string]$definitionType,
        [Parameter()]$definitionValue,
        [Parameter()][ValidateSet("network default", "ignore", "custom")][string]$perClientBandwidthSetting="network default",
        [Parameter()]$perClientBandwidthLimitUp,
        [Parameter()]$perClientBandwidthLimitDown,
        [Parameter()]$dscpTagValue,
        [Parameter()][ValidateSet("high", "normal", "low")][string]$trafficPriority="normal",
        [Parameter()][ValidateSet($true, $false)][bool]$defaultRulesEnabled,
        [Parameter()][switch]$resetRules,
        [Parameter()][switch]$resetRuleDefinitions,
        [Parameter()][bool]$commit=$true,
        [Parameter()]$mrkConfigState,
        [Parameter()][switch]$overRideNWid
    )

    $FunctionScope = $MyInvocation.MyCommand.Noun

    [System.Collections.ArrayList]$ruleset = @()
    if($PSBoundParameters.ContainsKey("mrkConfigState")){
        # Start to work with the provided config state object. Set this into the $global:mrkConfigState to
        #   make it available for consequtive function calls for the same object.
        # The settings in the NetworkTrafficAnalysis are generic and can be applied to any network without conflicts so we can allow overRideNWid
        if( $mrkConfigState.configType -eq $FunctionScope -and 
           ($mrkConfigState.NetworkId -eq $networkId -or $overRideNWid) ){
            
            $global:mrkConfigState = $mrkConfigState

        }
    }
    elseif($global:mrkConfigState.rules.count -gt 0 -and $mrkConfigState.NetworkId -eq $networkId){
        #simply use the global:mrkConfigState to (continue to) modify and/or commit
    }
    else{
        #either the global mrkConfigState isn't set ot the networkId changed since the last command.
        #get the current config and scope and store them in global mrkConfigState properties
        $global:mrkConfigState = Get-MrkNetworkMXTrafficShaping -networkId $networkId
        $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'networkId' -Value $networkId
        $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'configType' -Value $FunctionScope
    }
    
    if ( -not $resetRules ){
        #get the current set of rules for the MX network and determine or ask for the rule to work on (add/remove/change)
        #after this function the $workRule is either a new/empty object or the current state of an existing rule in which to make changes.
        [System.Collections.ArrayList]$ruleset = $global:mrkConfigState.rules
        #only if a specific rule/definition action is intended the rule-entry to work on must be captured in $workRule. Else we simply keep the full ruleset.
        if( $action -in "addRuleDefinition", "removeRuleDefinition", "changeRuleSetting", "removeRule" ){
            switch ($ruleset.Count)
            {
                #if no rules exist yet the array is empty and the (new) rule id will be always 1
                0 { $workRule = [PSCustomObject]@{}; $ruleId = 1; }
                #if 1 rule exists the array is 1 item and the rule id will be always 1
                1 { $workRule = $ruleset[0]; $ruleId = 1; }
                #if multiple rules exist and the id is not provided or an impossible value ask for the correct rule-id. if the rule-id is provided and in range select that rule.
                {$_ -gt 1} {
                    if ( $null -eq $ruleId -or $ruleId -gt $ruleset.Count ){
                        $ruleId = Read-Host -Prompt "More than one rules exist, please specify the Meraki dashboard rule number (between 1 and $($ruleset.Count)) of the rule to adjust."
                        if( $null -eq $ruleId -or $ruleId -gt $ruleset.Count ){
                            return "cannot continue without the correct priority id of the rule to adjust.";
                        }
                    }
                    $workRule = $ruleset[$ruleId -1];
                }
                Default {}
            }
        }
    }

    if (-not $PSBoundParameters.ContainsKey("defaultRulesEnabled")){
        $defaultRulesEnabled = $global:mrkConfigState.defaultRulesEnabled;
    }

    switch ($action)
    {
        "addRule" {
            #construct a new rule property based on the provided parameters and values
            #create an empty definitions rule property object, construct a definition type/value object and add it in to it.
            $definitions = @();
            if ( $definitionType -match "application" ){
                $PSoValue = [pscustomobject]$definitionValue;
            } else {
                $PSoValue = [string]$definitionValue;
            }
            $ruleDefinition = [PSCustomObject]@{
                type = $definitionType
                value = $PSoValue
            }
            $definitions += $ruleDefinition;

            #construct the perClientBandwidthLimits rule property
            if ($perClientBandwidthSetting -eq "custom"){
                if (-not $PSBoundParameters.ContainsKey("perClientBandwidthLimitUp")){
                    $perClientBandwidthLimitUp = Read-Host -Prompt 'pls specify the numeric LimitUp in kbps. E.g 2048 for 2048 kbps (2Mbps)';
                }
                if (-not $PSBoundParameters.ContainsKey("perClientBandwidthLimitDown")){
                    $perClientBandwidthLimitDown = Read-Host -Prompt 'pls specify the numeric LimitDown in kbps. E.g 2048 for 2048 kbps (2Mbps)';
                }
                $bandwidthLimits = [hashtable]@{limitUp = $perClientBandwidthLimitUp ; LimitDown = $perClientBandwidthLimitDown};
                $perClientBandwidthLimits = [hashtable]@{settings = $perClientBandwidthSetting ; bandwidthLimits = $bandwidthLimits};
            } else {
                $perClientBandwidthLimits = [hashtable]@{settings = $perClientBandwidthSetting};
            }

            #construct the new rule object
            $newrule = [pscustomobject]@{
                definitions = $definitions
                perClientBandwidthLimits = $perClientBandwidthLimits
                dscpTagValue = $dscpTagValue
                priority = $trafficPriority
            }

            #add this new rule to the existing rules. will be empty in case of initial L7 config and/or reset rule situation
            $applyRules = @()
            ForEach ($rule in $ruleset){
                $applyRules += $rule
            }
            $applyRules += $newrule

            #update the mrkConfigState object properties
            $global:mrkConfigState.defaultRulesEnabled = $defaultRulesEnabled
            $global:mrkConfigState.rules = $applyRules
            # $global:MXTrafficShapingConfig = [PSCustomObject]@{
            #     defaultRulesEnabled = $defaultRulesEnabled
            #     rules = $applyRules
            # }
        }
        "removeRule" {
            #the rule to remove is specified by the rule# number as shown in the dashboard. The ruleId parameter value is already checked.
            $ruleset.RemoveAt($ruleId -1)
            $applyRules = $ruleset

            #update the mrkConfigState object properties
            $global:mrkConfigState.defaultRulesEnabled = $defaultRulesEnabled
            $global:mrkConfigState.rules = $applyRules
            # $global:mrkConfigState = [PSCustomObject]@{
            #     defaultRulesEnabled = $defaultRulesEnabled
            #     rules = $applyRules
            # }
        }
        "addRuleDefinition" {
            #This adds a new definition to the $workRule as selected by $ruleId
            #The workrule properties are updated based on the provided parameters and values.
            #The updated definitions property is written into the $workRule.definitions
            #The updated workRule is written back into the rule-array at the same position in the array
            #The updated rules and defaultRulesEnabled setting is applied into $global:mrkConfigState
            [System.Collections.ArrayList]$definitions = @($workRule.definitions);
            if ( $definitionType -match "application" ){
                $PSoValue = [pscustomobject]$definitionValue;
            } else {
                $PSoValue = [string]$definitionValue;
            }
            $ruleDefinition = [PSCustomObject]@{
                type = $definitionType
                value = $PSoValue
            }
            $definitions += $ruleDefinition;

            #collect the current values of the other rule properties. check the $psboundParameters in case these are provided in-line
            if(-not $PSBoundParameters.ContainsKey("perClientBandwidthSetting")){
                $perClientBandwidthLimits = $workRule.perClientBandwidthLimits;
            } else {
                if ($perClientBandwidthSetting -eq "custom"){
                    if (-not $PSBoundParameters.ContainsKey("perClientBandwidthLimitUp")){
                        $perClientBandwidthLimitUp = Read-Host -Prompt 'pls specify the numeric LimitUp in kbps. E.g 2048 for 2048 kbps (2Mbps)';
                    }
                    if (-not $PSBoundParameters.ContainsKey("perClientBandwidthLimitDown")){
                        $perClientBandwidthLimitDown = Read-Host -Prompt 'pls specify the numeric LimitDown in kbps. E.g 2048 for 2048 kbps (2Mbps)';
                    }
                    $bandwidthLimits = [hashtable]@{limitUp = $perClientBandwidthLimitUp ;LimitDown = $perClientBandwidthLimitDown};
                    $perClientBandwidthLimits = [hashtable]@{settings = $perClientBandwidthSetting; bandwidthLimits = $bandwidthLimits};
                } else {
                    $perClientBandwidthLimits = [hashtable]@{settings = $perClientBandwidthSetting};
                }
            }

            if(-not $PSBoundParameters.ContainsKey("trafficPriority")){
                $trafficPriority = $workRule.priority;
            }

            if(-not $PSBoundParameters.ContainsKey("dscpTagValue")){
                $dscpTagValue = $workRule.dscpTagValue;
            }

            $newrule = [pscustomobject]@{
                definitions = $definitions
                perClientBandwidthLimits = $perClientBandwidthLimits
                dscpTagValue = $dscpTagValue
                priority = $trafficPriority
            }

            #this new rule will replace the old entry. remove the rule defined by ruleId and insert this new rule at the same position
            $ruleset.RemoveAt($ruleId -1)
            $ruleset.Insert($ruleId -1, $newrule)
            $applyRules = $ruleset
            
            #update the mrkConfigState object properties
            $global:mrkConfigState.defaultRulesEnabled = $defaultRulesEnabled
            $global:mrkConfigState.rules = $applyRules

            # $global:mrkConfigState = [PSCustomObject]@{
            #     defaultRulesEnabled = $defaultRulesEnabled
            #     rules = $applyRules
            # }

        }
        Default {}
    }

    if($commit){
        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/trafficShaping') -body $global:mrkConfigState ;
        return $request
    }

}