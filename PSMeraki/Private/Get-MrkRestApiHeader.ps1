function Get-MrkRestApiHeader {
    [CmdletBinding()]
    Param ()
    if (!$mrkRestApiKey){
        Set-MrkRestApiKey 
        Get-MrkRestApiHeader
    } Else {
       $global:mrkRestApiHeader = @{
        "X-Cisco-Meraki-API-Key" = $mrkRestApiKey
       }
       return $mrkRestApiHeader
    }
}