function Set-MrkRestApiKey {
    <#
    .SYNOPSIS
    Sets a Meraki Rest API key for a powershell session
    .DESCRIPTION
    REST API key is unique for each Meraki dashboard user. the REST API should be enabled organization wide, a dashboard user is able to create a key
    more info https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API
    .EXAMPLE
    Set-MrkRestApiKey
    .EXAMPLE
    Set-MrkRestApiKey 1234567890abcdefabcd1234567890abcdefabcd
    .PARAMETER key
    40 characters 0-9 a-f key that represents a logged in Meraki dashboard user
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true, HelpMessage="Enter Meraki REST API key")]
        [ValidateLength(40,40)]
        [ValidatePattern("[0-9A-F]+")]
        [String]$key
    )
    Write-Verbose "Set-MrkRestApiKey: Called, setting key"
    $script:mrkRestApiKey = $key
    #Get-MrkOrgEndpoint | Out-Null
}