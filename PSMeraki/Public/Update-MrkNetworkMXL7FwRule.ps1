function Update-MrkNetworkMXL7FwRule{
    <#
    .SYNOPSIS
    Adds a Meraki L7 Firewall rule to the given Meraki network.
    .DESCRIPTION
    Adds a Meraki L7 Firewall rule to the given Meraki network. 
    For MX series the firewall rules are set per NetworkID.
        PUT {{baseUrl}}/networks/{networkId}/l7FirewallRules
    .EXAMPLE
    Update-MrkNetworkMXL7FwRule -networkId X_112233445566778899 -policy Deny -type applicationCategory -value 
    Update-MrkNetworkMXL7FwRule -networkId X_112233445566778899 -policy Deny -type host -value malicious.domain.com 
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER policy
    This parameter is currently only available as 'deny' and determines if the rule is to deny (or allow?) a certain L7 destination
    .PARAMETER type
    This parameter is a fixed ValidateSet: "application", "applicationCategory","host","port","ipRange"
    * application(Category): this type requires a value of type array that provides an id and name of the Meraki-defined list of applications
    * host: this type requires a value of type string that names the host. E.g. www.somedomain.com
    * port: this type requires a value of type string that contains the portnumber that should be blocked
    * ipRange: this type requires a value of type string that contains the iprange (ip4v) that should be blocked
    .PARAMETER value
    The value is either a string or an array depending on the rule-type
    The array-value must be given like this: @{id="meraki:layer7/category/13";name="Video & music"}
    .PARAMETER action
    The action is add, remove or set.
        'add' will look in the list of existing rules and only add the provided rule if not present yet.
        'remove' will look in the list of existing rules and only remove it when it is present.
        'set' will take the configuration from the value provided to mrkConfigState, validate it and write it into the network configuration
    .PARAMETER reset
    Optional switch to determine if the cmdlet will keep the existing L3 Firewall rules or start with a clean set of rules and add only this new one.
    not specifying it or assigning $false will keep the existing rules (default).
    .PARAMETER commit
    Parameter (default $true) to control whether to commit the current rule-state of if a subsequent function-call is to be executed to add/remove
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
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet("add", "remove", "set")][string]$action,
        [Parameter()][ValidateSet("deny")][string]$policy="deny",
        [Parameter()][ValidateNotNullOrEmpty()][ValidateSet("application", "applicationCategory","host","port","ipRange")][string]$type,
        [Parameter()][ValidateNotNullOrEmpty()]$value,
        [Parameter()][switch]$reset,
        [Parameter()][bool]$commit=$true,
        [Parameter()]$mrkConfigState,
        [Parameter()][switch]$overRideNWid
    )

    $functionScope = $MyInvocation.MyCommand.Noun

    if(-not $PSBoundParameters.keys.Contains("type") -and $action -in "add", "remove"){
        $type = Read-Host -Prompt 'please set the ruletype ("application", "applicationCategory","host","port","ipRange")'
        if (-not $value){ $value = Read-Host -Prompt 'please set the value for the ruletype' }
    }

    if($PSBoundParameters.Keys.Contains("mrkConfigState")){
        # Start to work with the provided config state object. Set this into the $global:mrkConfigState to
        #   make it available for consequtive function calls for the same object.
        # The settings in the NetworkTrafficAnalysis are generic and can be applied to any network without conflicts so we can allow overRideNWid
        if( $mrkConfigState.configType -eq $functionScope -and 
           ($mrkConfigState.NetworkId -eq $networkId -or $overRideNWid) ){
            
            $global:mrkConfigState = $mrkConfigState

        }
        
    }
    elseif($global:mrkConfigState.NetworkId -eq $networkId -and $global:mrkConfigState.configType -eq $functionScope){
        # The $global:mrkConfigState is already set and contains settings,
        #  the provided networkId matches the NetworkId in the provided state,
        #  and the mrkConfigState.configType matches this function scope
        # --> continue with this state and modify/set it...
    }
    else{
        #get existing rules if any because either the networkId changed between commands
        #or the $global:mrkConfigState ruleset is empty ...
        $ruleset = @()
        if ($reset){
            $global:mrkConfigState = [PSCustomObject]@{}
            $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'rules' -Value $ruleset
        }
        else{
            $global:mrkConfigState = get-MrkNetworkMXL7FwRule -networkId $networkId
        }
        $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'networkId' -Value $networkId
        $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'configType' -Value $functionScope
    }

    #the value in the rule-object is an object itself that cannot be compared as string
    if ($type -match "application"){
        $PSoValue = [PSCustomObject]$value
    } else {
        $PSoValue = $value
    }

    #populate the to-be ruleset first with the existing rules (will be empty in case of reset)
    switch ($action){
        'set' {
            $applyRules = $global:mrkConfigState.rules
        }
        default {
            $ruleset = $global:mrkConfigState.rules
            $applyRules = @()
            ForEach ($rule in $ruleset){

                #if the action is delete and the rule specifications policy/type/value are equal do not add it back to the ruleset. 
                if ($action -eq 'remove' -and `
                ($rule.policy -eq $policy -and `
                    $rule.type -eq $type -and `
                    $rule.value -match $PSoValue)){
                        "No longer adding this rule: $value";
                        continue
                    }

                if ($action -eq 'add' -and `
                    ($rule.policy -eq $policy -and `
                    $rule.type -eq $type -and `
                    $rule.value -match $PSoValue)){
                        "Not adding new rule as it is already present: $value";
                        $rulePresent = $true
                    }
                
                #add this exising rule into the $ruleset object
                $ruleEntry = [PSCustomObject]@{
                    policy = $rule.policy
                    type   = $rule.type
                    value  = $rule.value
                }

                $applyRules += $ruleEntry
            }

            #append the new ruleobject to the applyRules
            if ($action -eq 'add' -and $true -ne $rulePresent){
                $ruleEntry = New-Object -TypeName PSObject -Property @{
                    policy = $policy
                    type   = $type
                    value  = $PSoValue
                }

                $applyRules += $ruleEntry
            };
        }
    }
    #add the new applyRules into the full ruleObject to push into the $body of the RestAPI request
    $global:mrkConfigState.rules = $applyRules
    # $ruleObject = New-Object -TypeName PSObject -Property @{
    #     rules = $applyRules
    # }

    if($true -ne $rulePresent){

        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/l7FirewallRules') -body $global:mrkConfigState
        return $request

    }
}