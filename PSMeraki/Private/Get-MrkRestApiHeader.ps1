function Get-MrkRestApiHeader {
    [CmdletBinding()]
    Param ()
    Write-Verbose "Get-MrkRestApiHeader: called"
    if (!$mrkRestApiKey){
        Write-Verbose "Get-MrkRestApiHeader: No REST API Key in memory, calling Set-MrkRestApiKey"
        Set-MrkRestApiKey
        Get-MrkRestApiHeader
    } Else {
        Write-Verbose "Get-MrkRestApiHeader: REST API Key is in memory, creating header"
        @{'X-Cisco-Meraki-API-Key' = $mrkRestApiKey}
    }
}