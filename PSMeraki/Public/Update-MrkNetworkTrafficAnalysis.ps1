Function Update-MrkNetworkTrafficAnalysis {
    <#
    .SYNOPSIS
    Update network traffic analysis settings for a network.
    .DESCRIPTION
    Update network traffic analysis settings for a network by adding / removing settings like host, port or IPRange to analyse.
    .EXAMPLE
    This will set the TrafficAnalysis to detailed of traffic to/from the IP-range '10.24.0.0/16' labeled as 'DC Traffic'.
    Update-MrkNetworkTrafficAnalysis -networkId N_1234567890123456 -action add -mode detailed -name 'DC Traffic' -type ipRange -value '10.24.0.0/16'
    .PARAMETER networkId
    The networkId of the network. Get the id using Get-MrkNetwork.
    .PARAMETER ruleId
    The Traffic analysis custom pie chart # id to remove or insert the new rule at.
    For example to remove rule identified by #2 run:
        Update-MrkNetworkTrafficAnalysis -action remove -ruleId 2

    For example to add a new rule at a certain position (top/bottom/specific number) run:
        Update-MrkNetworkTrafficAnalysis -action add -ruleId 2 -name 'DC Traffic' -type ipRange -value '10.24.0.0/26'
    When the ruleId is omitted the new rule is simply added at the end.
    
    .PARAMETER action
    The action to perform: add or remove a rule
    .PARAMETER mode
    The traffic analysis mode for the network. Can be one of 'disabled' (do not collect traffic types), 'basic' (collect generic traffic categories), or 'detailed' (collect destination hostnames).
    .PARAMETER name
    The name of the custom pie chart item.
    .PARAMETER type
    The signature type for the custom pie chart item. Can be one of 'host', 'port' or 'ipRange'.
    .PARAMETER value
    The value of the custom pie chart item. Valid syntax depends on the signature type of the chart item (see sample request/response for more details).
    .PARAMETER ruleId
    Parameter to determine the location/priority of the rule to add/remove/alter.
    The value can be 'top', 'bottom' or a numeric value as shown in the GUI of the Meraki dashboard.
    When you specify TOP and -action is 'add', you add a new rule which will be assigned the highest priority (rule# 1)
        if action is 'remove' the top-rule will be removed.
    When you specify TOP and -action is 'bottom', you add a new rule which will be assigned the lowest priority (rule# highest e.g 5)
        if action is 'remove' the bottom-rule will be removed.
    When you specify a numeric value the rule will either be added into the rule-collection at that position (action 'add')
        or be removed from the rule-collection at that position (action 'remove')
    .PARAMETER commmit
    Optional parameter to specify if you want to commit the change immediately or only add or remove the rule in the GLOBAL rulebase variable $global:MXTrafficAnalysis.
    This variable $global:MXTrafficAnalysis is retrieved from the network unless the RESET switch is provided and that $global:MXTrafficAnalysis is used to add/remove rules.
    After each add/remove iteration the $global:MXTrafficAnalysis is updated and once you provide the commit swith that leads to the API call to meraki.
    .PARAMETER configState
    Optional parameter to provide the ruleset to work with. When provided without any other rule remove/add action and use -commit, you apply the set as provided.
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet('add', 'remove', 'disable')][string]$action,
        [Parameter()][ValidateSet('disabled', 'basic', 'detailed')][string]$mode,
        [Parameter()][string]$name,
        [Parameter()][ValidateSet('host', 'port', 'ipRange')][string]$type,
        [Parameter()][string]$value,
        [Parameter()][string]$ruleId,
        [Parameter()][switch]$commmit,
        [Parameter()]$configState
    )

    if($configState){
        $global:MXTrafficAnalysis = $configState
    }
    elseif($global:MXTrafficAnalysis.count -gt 0 -and $global:MXNetworkId -eq $networkId){

    }
    else{
        #get existing rules if any because either the networkId changed between commands
        #or the $global:MXTrafficAnalysis ruleset is empty ...
        $global:MXTrafficAnalysis = Get-MrkNetworkTrafficAnalysis -networkId $networkId
    }

    if($null -eq $global:MXTrafficAnalysis.customPieChartItems){
        Write-Verbose 'current ruleset empty. initialise empty customPieChartItems array'
        [System.Collections.ArrayList]$customPieChartItems = @();
    }
    else{
        Write-Verbose 'current ruleset exists. Assign them to customPieChartItems array'
        [System.Collections.ArrayList]$customPieChartItems = $global:MXTrafficAnalysis.customPieChartItems
    }

    #get the current mode setting in case not provided 
    if(-not $PSBoundParameters.Keys.Contains("mode")){$mode = $global:MXTrafficAnalysis.mode}

    Write-Verbose "existing trafficAnalysisConfig before update: $global:MXTrafficAnalysis"

    switch($action){
        'add' {
            $newRule = [pscustomobject]@{
                name = $name
                type = $type
                value = $value
            }

            $ruleCount = $customPieChartItems.count

            if($PSBoundParameters.keys.Contains("ruleId")){
                if($ruleId -eq 'top'){$pos = 0}
                if($ruleId -eq 'bottom'){$pos = $ruleCount}
                if($ruleId -match "^[0-9]+$"){
                    if ($ruleId -gt $ruleCount){
                        Write-Host invalid ruleId value provided. Use a max of $ruleCount or type top/bottom;
                        break
                    }else{
                        #substract 1 from the provided ruleId as the displayed values start at 1 and the array starts at 0
                        $pos = $ruleId -1
                    }
                }
            }

            Write-Verbose "inserting a rule at position $pos in the array. Specified ruleId $ruleId"

            $customPieChartItems.Insert($pos,$newRule)
            $global:MXTrafficAnalysis = [PSCustomObject]@{
                mode = $mode
                customPieChartItems = $customPieChartItems
            }
        }
        'remove' {
            if($PSBoundParameters.keys.Contains("ruleId")){
                if($ruleId -eq 'top'){$pos = 0}
                if($ruleId -eq 'bottom'){$pos = $ruleCount}
                if($ruleId -match "^[0-9]+$"){
                    if ($ruleId -gt $ruleCount){
                        Write-Host invalid ruleId value provided. Use a max of $ruleCount or type top/bottom;
                        break
                    }else{
                        #substract 1 from the provided ruleId as the displayed values start at 1 and the array starts at 0
                        $pos = $ruleId -1
                    }
                }
            
                Write-Verbose "removing a rule from position $pos in the array. Specified ruleId '$ruleId'"

                $customPieChartItems.RemoveAt($pos)
                $global:MXTrafficAnalysis = [PSCustomObject]@{
                    mode = $mode
                    customPieChartItems = $customPieChartItems
                }
            } else {
                Write-Error 'you must provide a ruleId to remove. Use top/bottom or a number as shown in the dashboard in the traffic analysis section'
                break
            }
        }
        'disable' {
            $global:MXTrafficAnalysis = [PSCustomObject]@{
                mode = 'disabled'
            }
        }
    }

    Write-Verbose "updated body element $($global:MXTrafficAnalysis)"

    if($commit){
        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/trafficAnalysisSettings') -body $global:MXTrafficAnalysis
        return $request
    }
}