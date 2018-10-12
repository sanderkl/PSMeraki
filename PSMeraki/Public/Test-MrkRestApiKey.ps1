function Test-MrkRestApiKey {
    <#
    .SYNOPSIS
    Tests a Meraki Rest API key is it suits the syntax
    .DESCRIPTION
    Tests a Meraki Rest API key is it is 40 bytes long. 
    .EXAMPLE
    Test-MrkRestApiKey -apiKey 1234567890abcdefabcd1234567890abcdefabcd
    .PARAMETER apiKey
    40 characters 0-9 a-f key that represents a logged in Meraki dashboard user 
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    Param (
        [Parameter()][string]$apiKey
    )
    if ($apiKey.Length -ne 40){
        Write-Output "key length is not 40 bytes`, aborting.."
        return $false
    }
    return $true
} 