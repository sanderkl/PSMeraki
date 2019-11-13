function Get-MrkSwitchPort {
    <#
    .SYNOPSIS
    Retrieves all meraki switches for a Meraki network or a specific switch by serial number
    GET
        /devices/[serial]/switchPorts

    .DESCRIPTION
    Gets a list of all Meraki switchports of a switch in a Meraki network. 
    .EXAMPLE
    Get-MrkSwitchPort
    .EXAMPLE
    Get-MrkSwitchPort -serial X_112233445566778899
    .PARAMETER number
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER serial
    specify the device serialnumber
    #>

    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$serial,
        [Parameter()][string]$number
    )
    
    if(-not $number){
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/devices/' + $serial + '/switchPorts')
    }else{
        $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/devices/' + $serial + '/switchPorts/' + $number )
    }
    
    return $request
}