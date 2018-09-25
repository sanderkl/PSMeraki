function Set-MrkRestApiKey {
    <#
    .SYNOPSIS
    Sets a Meraki Rest API key for a powershell session
    .DESCRIPTION
    REST API key is unique for each Meraki dashboard user. the REST API should be enabled organization wide, a dashboard user is able to create a key
    more info https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API
    .EXAMPLE
    Get-MrkNetwork 
    .EXAMPLE
    Get-MrkNetwork 1234567890abcdefabcd1234567890abcdefabcd
    .PARAMETER key
    40 characters 0-9 a-f key that represents a logged in Meraki dashboard user 
    #>

    #https://blogs.technet.microsoft.com/heyscriptingguy/2011/05/18/real-world-powershell-tips-from-a-2011-scripting-games-winner/

    [CmdletBinding()]
    Param (
        [String]$key
    )
    if (!$mrkRestApiKey){
        $script:mrkRestApiKey = (Read-host Enter Meraki REST API key).Trim()
        Write-Host Key set`, to change the key in this session`, use  Set-MrkRestApiKey `<key`>    
    } 
    if ($key){
        $script:mrkRestApiKey = $key
        Write-Host New Key set
    }
    if (!(Test-MrkRestApiKey -apiKey $mrkRestApiKey)){
        Write-Host REST API Key is invalid
        break
    }
} 