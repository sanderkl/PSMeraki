function Get-MrkRestApiHeader {
    [CmdletBinding()]
    [OutputType('System.Collections.Generic.Dictionary')]
    Param ()
    if (!$mrkRestApiKey){
        Write-Verbose "Get-MrkRestApiHeader: No REST API Key in memory, calling Set-MrkRestApiKey"
        Set-MrkRestApiKey
        Get-MrkRestApiHeader
    } Else {
        Write-Verbose "Get-MrkRestApiHeader: REST API Key is in memory, creating header"
        #$script:mrkRestApiHeader = New-Object 'System.Collections.Generic.Dictionary[String,String]'
        #Write-Verbose "Get-MrkRestApiHeader: Make Disctionary"
        #$mrkRestApiHeader = New-Object 'System.Collections.Generic.Dictionary[String,String]'
        #[Collections.Generic.Dictionary[[String],[String]]]$mrkRestApiHeader
        Write-Verbose "Get-MrkRestApiHeader: Add data to Dictionary"
        #$mrkRestApiKey.GetType()
        #$mrkRestApiHeader.add('X-Cisco-Meraki-API-Key', $mrkRestApiKey)
        $mrkRestApiHeader = @{
            'X-Cisco-Meraki-API-Key' = $mrkRestApiKey
        }
    }
    return $mrkRestApiHeader
}