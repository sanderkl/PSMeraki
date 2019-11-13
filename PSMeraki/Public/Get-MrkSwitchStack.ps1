function Get-MrkSwitchStack {
    <#
    .SYNOPSIS
    Retrieves all meraki switches for a Meraki network or a specific switch by serial number
    GET
        /networks/{networkId}/switchStacks
        /networks/{networkId}/switchStacks/{switchStackId}

    .DESCRIPTION
    Gets a list of all Meraki switchStacks in a Meraki network. 
    .EXAMPLE
    Get-MrkSwitch
    .EXAMPLE
    Get-MrkSwitchStack -networkId X_112233445566778899
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER serial
    specify the device serialnumber
    #>

    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$networkId
    )
    
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/switchStacks')
            
    return $request
}