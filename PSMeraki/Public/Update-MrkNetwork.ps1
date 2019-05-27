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
    .EXAMPLE

    .EXAMPLE

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
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][String]$networkId,
        [Parameter(ParameterSetName="vlanstate")][bool]$enableVlanState,
        [Parameter(ParameterSetName="identity")][String]$name,
        [Parameter(ParameterSetName="identity")][String]$timeZone,
        [Parameter(ParameterSetName="identity")][String]$tags
    )

    if($EnableVlanState){
        $body = @{
            enabled = $EnableVlanState
        }
        #{{baseUrl}}/networks/{{networkId}}
        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/vlansEnabledState') -Body $body;
        #get the vlan enabled state for the network and add the return as noteproperty to the $request 

        return $request
    }
    if($PSCmdlet.ParameterSetName -eq "identity"){
        $body = @{
            name = $name
            timeZone = $timeZone
            tags = $tags
        }
        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId) -Body $body;
    }
}