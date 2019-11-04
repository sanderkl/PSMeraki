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
    Parameter to specify the action (set/modify) to perform to the content filtering configuration.
    When adding or removing a setting to the Content Filtering ruleset you can provide multiple parameters. Each parameter provided will be evaluated
    against to corresponding parameter-value that is present and updated if the value would change. If you want to update only 1 particular property you
    specify just that one property (e.g whitelistedUrlPatterns or blockedUrlPatterns or blockedUrlCategories) and only that property-value gets evaluate and
    updated if changed.
    .PARAMETER reset
    When this switch is present the function will start with a blanc ruleset. If omitted the function
        will first get the current content filtering configuration and perform the action (add/remove) to that set.
    .PARAMETER AddWhitelistedUrlPatterns
    Parameter (multivalued string) to provide the Url Pattern(s) to add to this setting
    Provide the value(s) to remove like:
        -AddWhitelistedUrlPatterns "*.domain1.com","*.domain2.com","*.domain3.com"
    .PARAMETER RemoveWitelistedUrlPatterns
    Parameter (multivalued string) to provide the Url Pattern(s) to remove from this setting
    Provide the value(s) to remove like:
        -RemoveWitelistedUrlPatterns "*.domain1.com","*.domain2.com","*.domain3.com"
    .PARAMETER AddBlockedUrlPatterns
    Parameter (multivalued string) to provide the Url Pattern(s) to add to this setting.
    Provide the value(s) to remove like:
        -AddBlockedUrlPatterns "*.domain4.com","*.domain5.com","*.domain6.com"
    .PARAMETER RemoveBlockedUrlPatterns
    Parameter (multivalued string) to provide the Url Pattern(s) to remove from this setting.
    Provide the value(s) to remove like:
        -RemoveBlockedUrlPatterns "*.domain4.com","*.domain5.com","*.domain6.com"
    .PARAMETER AddBlockedUrlCategories
    Parameter (multivalued string) to provide the Category Id value(s) to add to this setting specify the numerical value(s)
    of the categories to block only. For example:
        -AddBlockedUrlCategories 1,3,5,7
        This will block:"Real Estate","Financial Services","Computer and Internet Info","Shopping"
    Get the available category-list from the network using:
        Get-MrkNetworkMxCFCategory -networkId L_11223344556677 | ConvertTo-Json -Depth 10
    .PARAMETER RemoveBlockedUrlCategories
    Parameter (multivalued string) to provide the Category Id value(s) to remove from this setting specify the numerical value(s)
    of the categories to block only. For example:
        -RemoveBlockedUrlCategories 1,3,5,7
        This will remove from blocklist:"Real Estate","Financial Services","Computer and Internet Info","Shopping"
    Get the available category-list from the network using:
        Get-MrkNetworkMxCFCategory -networkId L_11223344556677 | ConvertTo-Json -Depth 10
    .PARAMETER urlCategoryListSize
    Either 'topSites' or 'fullList'.
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
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet("set", "modify")][string]$action,
        [Parameter()][string[]]$AddWhitelistedUrlPatterns,
        [Parameter()][string[]]$RemoveWhitelistedUrlPatterns,
        [Parameter()][string[]]$AddBlockedUrlPatterns,
        [Parameter()][string[]]$RemoveBlockedUrlPatterns,
        [Parameter()][string[]]$AddBlockedUrlCategories,
        [Parameter()][string[]]$RemoveBlockedUrlCategories,
        [Parameter()][ValidateSet("topSites", "fullList")]$urlCategoryListSize='topSites',
        [Parameter()][switch]$reset,
        [Parameter()][bool]$commit=$true,
        [Parameter()]$mrkConfigState,
        [Parameter()][switch]$overRideNWid
    )

    $FunctionScope = $MyInvocation.MyCommand.Noun

    if($PSBoundParameters.Keys.Contains("mrkConfigState")){
        # Start to work with the provided config state object. Set this into the $global:mrkConfigState to
        #   make it available for consequtive function calls for the same object.
        # The settings in the ContentFiltering rules are generic and can be applied to any network without conflicts so we can allow overRideNWid
        if( $mrkConfigState.configType -eq $FunctionScope -and 
           ($mrkConfigState.NetworkId -eq $networkId -or $overRideNWid) ){
            Write-Verbose -Message 'using provided -mrkConfigState parameter'
            $global:mrkConfigState = $mrkConfigState
        }
        else{
            Write-Verbose -Message "provided state-object does not match the current specified target. Cannot continue"
            return
        }
    }
    elseif($global:mrkConfigState.NetworkId -eq $networkId -and $global:mrkConfigState.configType -eq $FunctionScope -and (-not $reset) ){
        # The $global:mrkConfigState is already set and contains settings and the provided networkId matches the NetworkId in the provided state.
        Write-Verbose -Message 'using existing global:mrkConfigState values'
    }
    else{
        #get existing rules if any because either the networkId changed between commands
        #or the $global:MXTrafficAnalysis ruleset is empty ...
        if ($reset){
            Write-Verbose -Message 'building new global:mrkConfigState object with empty values'
            $global:mrkConfigState = [PSCustomObject]@{}
            $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'urlCategoryListSize' -Value $urlCategoryListSize
            $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'blockedUrlCategories' -Value @()
            $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'blockedUrlPatterns' -Value @()
            $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'allowedUrlPatterns' -Value @()
        }
        else{
            Write-Verbose -Message 'setting global:mrkConfigState object with values from this network'
            $global:mrkConfigState = get-MrkNetworkMXCfRule -networkId $networkId
        }
        $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'networkId' -Value $networkId
        $global:mrkConfigState | Add-Member -MemberType NoteProperty -Name 'configType' -Value $functionScope
    }

    #based on presence of the various parameters and values update the state
    $existingCFCategories = (Get-MrkNetworkMxCFCategory -networkId $networkId).categories.id
    if($AddBlockedUrlCategories){
        write-verbose -message 'start adding the new BlockedUrlCategories'
        [System.Collections.ArrayList]$blockedUrlCategories = $global:mrkConfigState.blockedUrlCategories
        foreach($catId in $AddBlockedUrlCategories){
            #check if the provided id exists in the meraki platform definitions
            $catIdValue = 'meraki:contentFiltering/category/' + $catId
            if($existingCFCategories.contains($catIdValue)){
                $global:mrkConfigState.blockedUrlCategories += @{id=$catIdValue};
            }
        }
    }
    if($RemoveBlockedUrlCategories){
        write-verbose -message 'build an empty arraylist to populate with remaining BlockedUrlCategory idd'
        $blockedUrlCategories = [System.Collections.ArrayList]@()
        foreach($UrlCat in $global:mrkConfigState.blockedUrlCategories){
            #the $id is in the format meraki:contentFiltering/category/##. trim to just the number and check if the number is in the RemoveBlockedUrlCategories array
            $id = $UrlCat.Id.split('/')[-1]
            if($id -notin $RemoveBlockedUrlCategories){
                $blockedUrlCategories += $UrlCat;
            }
        }
        $global:mrkConfigState.blockedUrlCategories = $blockedUrlCategories
    }
    if($AddWhitelistedUrlPatterns){
        write-verbose -message 'adding new URL Patterns to the allowedUrlPatterns'
        foreach($pattern in $AddWhitelistedUrlPatterns){
            if($pattern -notin $global:mrkConfigState.allowedUrlPatterns){
                $global:mrkConfigState.allowedUrlPatterns += $pattern;
            }
        }
    }
    if($RemoveWhitelistedUrlPatterns){
        write-verbose -message 'removing URL Patterns from the allowedUrlPatterns'
        $UrlPatterns = [System.Collections.ArrayList]
        foreach($UrlPatt in $global:mrkConfigState.allowedUrlPatterns){
            if($UrlPatt -notin $RemoveWhitelistedUrlPatterns){
                $UrlPatterns += $UrlPatt;
            }
        }
        $global:mrkConfigState.allowedUrlPatterns = $UrlPatterns
    }
    if($AddBlockedUrlPatterns){
        write-verbose -message 'adding URL Patterns to the blockedUrlPatterns'
        foreach($pattern in $AddBlockedUrlPatterns){
            if($pattern -notin $global:mrkConfigState.allowedUrlPatterns){
                $global:mrkConfigState.blockedUrlPatterns += $pattern;
            }
        }
    }
    if($RemoveBlockedUrlPatterns){
        write-verbose -message 'removing URL Patterns from the blockedUrlPatterns'
        $UrlPatterns = [System.Collections.ArrayList]
        foreach($UrlPatt in $global:mrkConfigState.allowedUrlPatterns){
            if($UrlPatt -notin $RemoveBlockedUrlPatterns){
                $UrlPatterns += $UrlPatt;
            }
        }
        $global:mrkConfigState.blockedUrlPatterns = $UrlPatterns
    }

    Write-Verbose ($global:mrkConfigState | ConvertTo-Json -Depth 10)

    if( ($true -eq $objectChanged -and $commit) -or $commit){
        # The PUT body object-model differs from the structure that is retreived by GET and needs to be updated to let the Meraki API accept it.
        # The difference is in the descriptor for the array object of the blockedUrlCategories:
        # blockedUrlCategories: [
        #   {
        #     "id":  "meraki:contentFiltering/category/67",
        #     "name":  "Bot Nets"
        #   },
        #   {
        #     "id":  "meraki:contentFiltering/category/68",
        #     "name":  "Abortion"
        #   }
        # ]
        # ... must become:
        # blockedUrlCategories: [
        #   "meraki:contentFiltering/category/67",
        #   "meraki:contentFiltering/category/68",
        # ]
        # so only the id-propertvalues must be in the body without the id tag itself.
        # retrieve the id-fields and overwrite that blockedUrlCategories property in the object.
        
        $blockedUrlCategories = $global:mrkConfigState.blockedUrlCategories.id | Select-Object -Unique
        $cfbody = [PSCustomObject]@{
            urlCategoryListSize = $global:mrkConfigState.urlCategoryListSize
            blockedUrlCategories = $blockedUrlCategories
            blockedUrlPatterns = $global:mrkConfigState.blockedUrlPatterns
            allowedUrlPatterns = $global:mrkConfigState.allowedUrlPatterns
        }

        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/contentFiltering') -body $cfbody
        return $request

    }

}