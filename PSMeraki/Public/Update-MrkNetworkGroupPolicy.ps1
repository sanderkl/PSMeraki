function Update-MrkNetworkGroupPolicy {
    <#
    .SYNOPSIS
    Retrieves all group policies for a Meraki network
    .DESCRIPTION
    Gets a list of all group policies in a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkGroupPolicy -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$name,
        [Parameter()][bool][ValidateSet($true,$false)]$schedulingEnabled=$false,
        [Parameter()][string[]]$schedule,
        [Parameter()][ValidateSet('network default','ignore', 'custom')][string]$bandwithSettings,
        [Parameter()][int]$bandwidthLimitUp=0,
        [Parameter()][int]$bandwidthLimitDown=0,
        [Parameter()][ValidateSet('network default','ignore', 'custom')][string]$firewallAndTrafficShapingSettings,
        [PSCustomObject]$firewallAndTrafficShaping,
        [PSCustomObject]$contentFiltering,
        [string]$splashAuthSettings,
        [PSCustomObject]$vlanTagging,
        [PSCustomObject]$bonjourForwarding,
        [Parameter()]$mrkConfigState
    )
    #Build body
    #try to get existing
    $mrkConfig = Get-MrkNetworkGroupPolicy -networkId $networkID | Where-Object name -eq $name ;

    if($mrkConfig){
        $groupPolicyId = $mrkConfig.groupPolicyId
    }else{
        $mrkConfig = [PSCustomObject]@{}
    }

    if($mrkConfigState){$mrkConfig = $mrkConfigState}

    foreach ($key in $PSBoundParameters.keys){
        switch($key){

            {$key -in 'networkID','mrkConfigState'} {
                #skip
            }

            default {
                $mrkConfig | Add-Member -MemberType NoteProperty -Name $key -Value $PSBoundParameters.item($key) -Force
            }
        }
        # $mrkConfig  = @{
        #     "name" = $name
        #     "scheduling" = $scheduling
        #     "bandwith" = $bandwith
        #     "firewallAndTrafficShaping" = $firewallAndTrafficShaping
        #     "contentFiltering" = $contentFiltering
        #     "splashAuthSettings" = $splashAuthSettings
        #     "vlanTagging" = $vlanTagging
        #     "bonjourForwarding" = $bonjourForwarding
        # }
    }

    If($groupPolicyId){
        $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkID + '/groupPolicies/' + $groupPolicyId) -Body $mrkConfig
    }
    else{
        $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkID + '/groupPolicies') -Body $mrkConfig
    }

    return $request
}