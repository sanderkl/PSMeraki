function Get-MrkNetwork {
    <#
    .SYNOPSIS
    Retrieves all meraki networks
    .DESCRIPTION
    Retrieves all meraki networks for an organization or a single network if the networkId is provided
    .EXAMPLE
    Get-MrkNetwork
    .EXAMPLE
    Get-MrkNetwork -OrgId 111222
    .EXAMPLE
    Get-MrkNetwork -networkId L_564638803281579210
    .PARAMETER orgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    .PARAMETER networkId
    optional parameter to specify a specific networkId. This function-call for example used to dynamically retrieve a specific
    network and then use the retrieved id to get settings from that specific network like vlans and vlan enabled status
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID),
        [Parameter()][String]$networkId
    )
    if($null -eq $networkId -or "" -eq $networkId){
        #{{baseUrl}}/organizations/{{organizationId}}/networks
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $orgId + '/networks')

    } else {
        #{{baseUrl}}/networks/{{networkId}}
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId);
        #get the vlan enabled state for the network and add the return as noteproperty to the $request
        $vlansEnabledState = (Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/vlansEnabledState')).enabled;
        $request | Add-Member -MemberType NoteProperty -Name vlansEnabledState -Value $vlansEnabledState
    }
    return $request
}