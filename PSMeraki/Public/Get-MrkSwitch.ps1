function Get-MrkSwitch {
    <#
    .SYNOPSIS
    Retrieves all meraki switches for a Meraki network or a specific switch by serial number
    GET
        /devices/[serial]/switchPorts
        /devices/[serial]/switchPorts/[number]
        /networks/[networkId]/switch/settings
        /networks/{networkId}/switchStacks
        /networks/{networkId}/switchStacks/{switchStackId}

    PUT
        /devices/[serial]/switchPorts/[number]
        /networks/[networkId]/switch/settings

    .DESCRIPTION
    Gets a list of all Meraki switches in a Meraki network.
    .EXAMPLE
    Get-MrkSwitch
    .EXAMPLE
    Get-MrkSwitch -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER serial
    specify the device serialnumber
    #>
    [CmdletBinding(DefaultParameterSetName='network')]
    Param (
        [Parameter(Mandatory,ParameterSetName='network')][ValidateNotNullOrEmpty()][String]$networkId,
        [Parameter(Mandatory,ParameterSetName='serial')][ValidateNotNullOrEmpty()][String]$serial
    )
    switch ($PsCmdlet.ParameterSetName) {
        "network" {
            Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/switch/settings"
        }
        "serial" {
            if ($mrkApiVersion -eq 'v0'){
                Invoke-MrkRestMethod -Method GET -ResourceID "/devices/$serial/switchPorts"
            } Else { #mrkApiVersion v1
                Invoke-MrkRestMethod -Method GET -ResourceID "/devices/$serial/switch/ports"
            }
        }
    }
}