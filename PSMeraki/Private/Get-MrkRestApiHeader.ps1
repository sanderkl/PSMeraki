function Get-MrkRestApiHeader {
    [CmdletBinding()]
    [OutputType('System.Collections.Generic.Dictionary')]
    Param ()
    if (!$mrkRestApiKey){
        Set-MrkRestApiKey
        Get-MrkRestApiHeader
    } Else {
       $script:mrkRestApiHeader = New-Object 'System.Collections.Generic.Dictionary[String,String]'
       $mrkRestApiHeader.add("X-Cisco-Meraki-API-Key", $mrkRestApiKey)
       }
       return $mrkRestApiHeader
    }
