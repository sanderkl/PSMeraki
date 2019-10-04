Function Update-MrkNetworkMXCfRule{
    <#
    UNDER CONSTRUCTION
    .SYNOPSIS
    Update the configuration of the content filtering for the MX network.
    .DESCRIPTION
    Update the configuration of the content filtering for the MX network.
    .EXAMPLE
    Update-MrkNetworkMXCfRule -networkId L_11223344556677 -urlCategoryListSize topSites -allowedUrlPatterns "" 
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER action
    Parameter to specify the action (add/remove) to perform to the content filtering configuration.
    When adding or removing a setting to the Content Filtering ruleset you can provide multiple parameters. Each parameter provided will be evaluated
    against to corresponding parameter-value that is present and updated if the value would change. If you want to update only 1 particular property you
    specify just that one property (e.g whitelistedUrlPatterns or blockedUrlPatterns or blockedUrlCategories) and only that property-value gets evaluate and
    updated if changed.
    .PARAMETER reset
    When this switch is present the function will start with a blanc ruleset. If omitted the function
        will first get the current content filtering configuration and perform the action (add/remove) to that set.
    .PARAMETER whitelistedUrlPatterns
    Parameter (multivalued string) to provide the Url Pattern(s) to add or remove to this setting
    Provide the value(s) to remove like:
        -blockedUrlPatterns "*.domain1.com","*.domain2.com","*.domain3.com"
    .PARAMETER blockedUrlPatterns
    Parameter (multivalued string) to provide the Url Pattern(s) to add or remove to this setting.
    Provide the value(s) to remove like:
        -blockedUrlPatterns "*.domain4.com","*.domain5.com","*.domain6.com"
    .PARAMETER blockedUrlCategories
    Parameter (multivalued string) to provide the Category Id value(s) to add or remove to this setting specify the numerical value(s)
    of the categories to block only. For example:
        -whitelistedUrlPatterns 1,3,5,7
        This will block:"Real Estate","Financial Services","Computer and Internet Info","Shopping"
    Get the available category-list from the network using:
        Get-MrkNetworkMxCFCategory -networkId L_11223344556677 | ConvertTo-Json -Depth 10
    .PARAMETER urlCategoryListSize
    Either 'topSites' or 'fullList'.
    .PARAMETER commit
        optional parameter to specify if you want to commit the change immediately or only add or remove the rule in the GLOBAL rulebase variable $global:MXCFRuleSetState.
        This variable $global:MXCFRuleSetState is retrieved from the network unless the RESET switch is provided and that $global:MXCFRuleSetState is used to add/remove rules.
        After each add/remove iteration the $global:MXCFRuleSetState is updated and once you provide the commit swith that leads to the API call to meraki.
    .PARAMETER RuleSetState
        optional parameter to provide the ruleset to work with. When provided without any other rule remove/add action you apply the set as provided.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet("add", "remove", "set")][string]$action,
        [Parameter()][string[]]$allowedUrlPatterns,
        [Parameter()][string[]]$blockedUrlPatterns,
        [Parameter()]$blockedUrlCategories,
        [Parameter()][ValidateSet("topSites", "fullList")]$urlCategoryListSize,
        [Parameter()][switch]$reset,
        [Parameter()][switch]$commit,
        [Parameter()]$RuleSetState
    )

    #$ruleset = @()
    if ($reset){
        #clear the $global:MXCFRuleSetState and optionally populate it with the provided RuleSetState
        $global:MXCFRuleSetState = @()
        if($RuleSetState){
            $global:MXCFRuleSetState = $RuleSetState
        }
    }
    elseif(($global:MXCFRuleSetState.blockedUrlCategories.count -gt 0 -or $global:MXCFRuleSetState.blockedUrlPatterns.count -gt 0 -or $global:MXCFRuleSetState.allowedUrlPatterns.count -gt 0 ) -and $global:MXNetworkId -eq $networkId){
        #continue with the current global MXCFRuleSetState as it seems a valid set and the global networkId is the same as the current network
    }
    else{
        #not resetting and the current network is different from the previous run, or the $global:MXCFRuleSetState isn't initialized yet.
        #read the current L3 firewallrules into the global $global:MXCFRuleSetState and set the $global:MXNetworkId to this network id.
        #This makes the $global:MXCFRuleSetState usable for the next iteration if the $RuleSetState and $reset are not provided.
        $global:MXCFRuleSetState = Get-MrkNetworkMXCfRule -networkId $networkId
        $global:MXNetworkId = $networkId
    }

    #based on presence of the PSBoundParameter the corresponding value will be retrieved from the $global:MXCFRuleSetState and based on the action


    #construct the full ruleObject to push into the $body of the RESTapi request
    $ruleObject = New-Object -TypeName PSObject -Property @{
        urlCategoryListSize = $urlCategoryListSize
        blockedUrlCategories = $colBlockedUrlCategories
        blockedUrlPatterns = $colBlockedUrlPatterns
        allowedUrlPatterns = $colAllowedUrlPatterns
    }

    Write-Verbose ($ruleObject | ConvertTo-Json -Depth 10)

    if( ($true -eq $objectChanged -and $commit) -or $commit){

        #$request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/contentFiltering') -body $ruleObject
        #return $request

    }

}