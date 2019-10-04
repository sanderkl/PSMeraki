function Update-MrkNetworkIDPSetting {
    <#
    .SYNOPSIS
    Retrieves the Network Security Intrusion Settings applied to a network
    .DESCRIPTION
    Describe the function in more detail
    .EXAMPLE
    Update-MrkNetworkIDPSetting 
    .EXAMPLE
    Update-MrkNetworkIDPSetting -networkId L_123456789012345678
    .PARAMETER networkId
    parameter to specify a specific networkId. This function-call for example used to dynamically retrieve a specific
    network and then use the retrieved id to get settings from that specific network like vlans and vlan enabled status
    .PARAMETER mode
    Possible values: 'disabled','detection','prevention'
    .PARAMETER idsRulesets
    Possible values: 'connectivity','balanced','security'
    .PARAMETER includedCidr
    a multi-value string property to define the network address CIDR notation(s). This property is currently not processed by this function and requires the network to be in passthrough-mode.
    in 
    .PARAMETER excludedCidr
    a multi-value string property to define the network address CIDR notation(s). This property is currently not processed by this function and requires the network to be in passthrough-mode.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][string]$networkId,
        [Parameter()][ValidateSet('disabled','detection','prevention')][string]$mode,
        [Parameter()][ValidateSet('connectivity','balanced','security')][string]$idsRulesets,
        [Parameter()][string[]]$includedCidr,
        [Parameter()][string[]]$excludedCidr
    )

    # $protectedNetworks = New-Object -TypeName PSObject -Property @{
    #     useDefault = $true
    # }

    $ruleSet = New-Object -TypeName PSObject -Property @{
        mode = $mode
        idsRulesets = $idsRulesets
    }

    #{baseUrl}/networks/{networkId}/security/intrusionSettings
    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/security/intrusionSettings') -body $ruleSet ;

    return $request
}