function set-MrkSwitchPort {
    <#
    .SYNOPSIS
    Sets the properties of a Switchport
    .DESCRIPTION
    blah 
    .EXAMPLE
    set-MrkSwitchPort -switchname ($locationcode+"-MS120-SW1") -Port $i -enabled True -Portname DATA/VOICE -vlan 500 -voicevlan 600 -type access -POEenabled True 
    .PARAMETER serial 
    Teh serial number of the switch
    .PARAMETER switchname 
    the name of the switch
    .PARAMETER port 
    the switch-portnumber to work on
    .PARAMETER portName
    the name to set on the port
    .PARAMETER tags
    the tag(s) to identify the switch
    .PARAMETER enabled
    parameter to control if the port is enabled or disabled
    .PARAMETER POEenabled
    parameter to control the Power Over Ethernet state
    .PARAMETER type
    parameter to specify the port-type: access or trunk
    .PARAMETER vlan
    parameter to define the VLAN id(s) the port operates in. Accessport can be in 1 VLAN only
    .PARAMETER voiceVlan
    parameter to define the VLAN id for voice
    #>

     [CmdletBinding()]

    param (
    
        [Parameter(Mandatory = $true)][string][ValidateNotNullOrEmpty()]$serial,
        [Parameter(Mandatory = $true)][string][ValidateNotNullOrEmpty()]$number,
        [Parameter()][string][ValidateNotNullOrEmpty()]$name="",
        [Parameter()][string][ValidateNotNullOrEmpty()]$tags="",
        [Parameter()][bool][ValidateSet($true,$false)]$enabled=$false,
        [Parameter()][bool][ValidateSet($true,$false)]$poeEnabled=$false,
        [Parameter()][string][ValidateSet('trunk','access')]$type="",
        [Parameter()][string][ValidateNotNullOrEmpty()]$vlan="",
        [Parameter()][string][ValidateNotNullOrEmpty()]$voiceVlan="",
        [Parameter()][string[]][ValidateNotNullOrEmpty()]$allowedVlans=""
        #[Parameter(Mandatory = $false)][Bool][ValidateNotNullOrEmpty()]$isolationEnabled,
        #[Parameter(Mandatory = $false)][Bool][ValidateNotNullOrEmpty()]$rstpEnabled,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$stpGuard,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$accessPolicyNumber,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$linkNegotiation,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$portScheduleId,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$udld,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$macWhitelist,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$stickyMacWhitelist,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$stickyMacWhitelistLimit
    )

    $mrkConfig = Get-MrkSwitchPort -serial $serial -number $number

    if ($mrkConfig){

    #$api = @{

    #     "endpoint" = 'https://n35.meraki.com/api/v0'
    
    #}

        Foreach($key in $PSBoundParameters.Keys){
            switch ($key){
                'serial' {}
                'allowedVlans' {
                    $mrkConfig.$key = $PSBoundParameters.item($key) -join ','
                } 
                default {
                    $mrkConfig.$key = $PSBoundParameters.item($key)
                }
            }
        }

        $mrkConfig.psobject.properties.Remove('stickyMacWhitelistLimit')
        $mrkConfig.psobject.properties.Remove('stickyMacWhitelist')
        $mrkConfig.psobject.properties.Remove('macWhitelist')

        Write-Verbose $mrkConfig | ConvertTo-Json -Depth 10

        $request = (Invoke-mrkRestMethod -Method PUT -ResourceID ('/devices/' + $serial + '/switchPorts/' + $number) -Body $mrkConfig)
        return $request
    
    }
    else{

        Write-Host "Switch doesn't exist." -ForegroundColor Red
    
    }

}