function Update-MrkNetwork {
    <#
    .SYNOPSIS
    Update a network by networkId. You can enable/disable the VLAN-state or change the identification values like name, timezone and tags.
    .DESCRIPTION
    Meraki networks are identified by name, timezone and tags. Additionally the network itself holds the vlansEnabledState setting. To add vlans
    to a network this setting must be set first.
    .EXAMPLE
    this will set the
    Update-MrkNetwork -networkId N_1234567890123456 -EnableVlanState
    Update-MrkNetwork -networkId N_1234567890123456 -name 'Office LA' -timeZone 'America/Los_Angeles' -tags "USA LA"
    .PARAMETER orgId
    (optional) parameter to specify the Meraki Organization id to invoke the REST call to
    .PARAMETER networkId
    the networkId of the network. Get the id using Get-MrkNetwork
    .PARAMETER enableVlanState
    this parameter is a boolean. $true will enable the VLAN support, $false will disable it.
    .PARAMETER name
    this parameter sets the network name
    .PARAMETER timeZone
    this parameter specifies the timezone for the network. This expects a fixed format know to Meraki.
    To get the available timezone values set it via the GUI and use Get-MrkNetwork -networkId to list the available values and reuse that information.
    .PARAMETER tags
    this optional parameter sets the tags to assign rules/permissions based on tag-value.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][String]$networkId,
        [Parameter(ParameterSetName="vlanstate")][bool]$enableVlanState,
        [Parameter(ParameterSetName="identity")][String]$name,
        [Parameter(ParameterSetName="identity")][String]$timeZone,
        [Parameter(ParameterSetName="identity")][String]$tags
    )

    if($EnableVlanState){
        if ($mrkApiVersion -eq 'v0'){
            $body = @{
                enabled = $EnableVlanState
            }
            Invoke-MrkRestMethod -Method PUT -ResourceID "/networks/$networkId/vlansEnabledState" -Body $body;
        } Else { #mrkApiVersion v1
            $body = @{
                vlansEnabled = $EnableVlanState
            }
            Invoke-MrkRestMethod -Method PUT -ResourceID "/networks/$networkId/appliance/vlans/settings" -Body $body;
        }
    }
    if($PSCmdlet.ParameterSetName -eq "identity"){
        $body = @{
            name = $name
            timeZone = $timeZone
            tags = $tags
        }
        Invoke-MrkRestMethod -Method PUT -ResourceID "/networks/$networkId" -Body $body;
    }
}