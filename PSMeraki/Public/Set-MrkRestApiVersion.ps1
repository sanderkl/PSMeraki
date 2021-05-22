function Set-MrkRestApiVersion {
    <#
    .SYNOPSIS
    Sets a Meraki Rest API version for a PowerShell session
    .DESCRIPTION
    Two published API verisons so far, v0 and v1. the module supports both making the new version backward compatible. 
    .EXAMPLE
    Set-MrkRestApiVersion -version v0
    .PARAMETER version
    possible values v0 and v1
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory)]
        [ValidateSet('v0','v1')]
        [String]$Version
    )
    Switch ($Version){
        "v0" {$global:mrkApiVersion = 'v0'}
        "v1" {$global:mrkApiVersion = 'v1'}
        default {Write-Host Error determining version;break}
    }
}