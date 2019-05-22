function Update-MrkNetwork {
    <#
    .SYNOPSIS
    
    .DESCRIPTION

    .EXAMPLE

    .EXAMPLE

    .EXAMPLE

    .PARAMETER OrgId

    .PARAMETER networkId

    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][String]$networkId,
        [Parameter(ParameterSetName="vlanstate")][switch]$EnableVlanState,
        [Parameter(ParameterSetName="identity")][String]$name,
        [Parameter(ParameterSetName="identity")][String]$timeZone,
        [Parameter(ParameterSetName="identity")][String]$tags
    )

    if($EnableVlanState){
        $body = @{
            enabled = $true
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