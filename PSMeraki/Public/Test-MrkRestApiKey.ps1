function Test-MrkRestApiKey {
    [CmdletBinding()]
    [OutputType([bool])]

    Param (
        [Parameter()][string]$apiKey
    )
    if ($apiKey.Length -ne 40){
        Write-Output "key length is not 40 bytes`, aborting.."
        break 
    }
    return $true
} 