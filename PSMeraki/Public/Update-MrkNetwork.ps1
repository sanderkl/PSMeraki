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

    .PARAMETER networkId
    the networkId of the network. Get the id using Get-MrkNetwork
    .PARAMETER EnableVlanState
    this parameter is a boolean. $true will enable the VLAN support, $false will disable it.
    .PARAMETER name

    .PARAMETER timeZone

    .PARAMETER tags

    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][String]$networkId,
        [Parameter(ParameterSetName="vlanstate")][bool]$EnableVlanState,
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