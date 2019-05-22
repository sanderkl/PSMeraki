function set-MrkSwitchPort {
    <#
    .SYNOPSIS
    Sets the properties of a Switchport
    .DESCRIPTION
    blah 
    .EXAMPLE
    set-MrkSwitchPort -switchname ($locationcode+"-MS120-SW1") -Port $i -enabled True -Portname DATA/VOICE -vlan 500 -voicevlan 600 -type access -POEenabled True 
    .PARAMETER NetworkId 
    id of a network get one using: (Get-MrkNetwork).id
    .PARAMETER SerialNr 
    Serial number of the physical device that is added to the network. 
    #>

     [CmdletBinding()]

    param (
    
        [Parameter(Mandatory = $true)][String][ValidateNotNullOrEmpty()]$switchname,
        [Parameter(Mandatory = $true)][String][ValidateNotNullOrEmpty()]$Port,
        [Parameter()][String][ValidateNotNullOrEmpty()]$Portname="",
        [Parameter()][String][ValidateNotNullOrEmpty()]$Tags="",
        [Parameter()][String][ValidateSet('True', 'False')]$enabled="False",
        [Parameter()][String][ValidateSet('True', 'False')]$POEenabled="False",
        [Parameter()][String][ValidateSet('trunk','access')]$type="",
        [Parameter()][String][ValidateNotNullOrEmpty()]$vlan="",
        [Parameter()][String][ValidateNotNullOrEmpty()]$Voicevlan=""
        #[Parameter(Mandatory = $false)][Bool][ValidateNotNullOrEmpty()]$isolation,
        #[Parameter(Mandatory = $false)][Bool][ValidateNotNullOrEmpty()]$rstp,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$stp,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$AccessPolicyNumber,
        #[Parameter(Mandatory = $false)][String][ValidateNotNullOrEmpty()]$linkNegotiation
    )
    
   

    $enabledx=$false
    if ($enabled -eq "True") { $enabledx=$true} else { $enabledx=$false}

    $poeenabledx=$false
    if ($poeenabled -eq "True") { $poeenabledx=$true} else { $poeenabledx=$false}


    $switch = Get-MrkSwitch $network.id | Where-Object {$_.name -eq $switchname}

    if ($switch){

        #$api = @{

       #     "endpoint" = 'https://n35.meraki.com/api/v0'
    
        #}

        $body = @{
            "name"=$Portname
            "enabled"=$enabledx
            "tags"=$tags
            "poeEnabled"=$poeenabledx
            "type"=$type
            "vlan"=$vlan
            "voiceVlan"=$voicevlan
            #"isolationEnabled"=$isolation
            #"rstpEnabled"=$rstp
            #"stpGuard"=$stp
            #"accessPolicyNumber"=$accessPolicyNumber
            #"linkNegotiation"=$linkNegotiation
            }


        #$body = convertto-json ($body)

        #$header = @{
        
        #    "X-Cisco-Meraki-API-Key" = $mrkapi
        #    "Content-Type" = 'application/json'
        
       # }

        #$api.url = "/devices/" + $switch.serial + "/switchPorts/"+ $port
        #$uri = $api.endpoint + $api.url
        #$request = (Invoke-RestMethod -Method PUT -Uri $uri -Headers $header -Body $body)
        $request = (Invoke-mrkRestMethod -Method PUT -ResourceID ('/devices/' + $switch.serial + '/switchPorts/' + $port) -Body $body)
        return $request
    
    }
    else{

        Write-Host "Switch doesn't exist." -ForegroundColor Red
    
    }

}