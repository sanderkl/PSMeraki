function Get-MrkRestApiHeader {
    if (!$mrkRestApiKey){
        Set-MrkRestApiKey 
        Get-MrkRestApiHeader
    } Else {
       $mrkRestApiHeader = @{
        "X-Cisco-Meraki-API-Key" = $mrkRestApiKey
       }
       return $mrkRestApiHeader
    }
}