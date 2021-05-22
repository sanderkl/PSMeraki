function Get-MrkOrgEndpoint {
    <#
    .DESCRIPTION
    PowerShell cmdlet has trouble with the redirection Meraki uses, from api.meraki.com to the organization specific url ( such as n210.meraki.com).
    To work around this issue this function retrieves the oranization specific URL and uses it for all cmdlets.
    The global variable orgBaseUri is set here and used in the invoke restmethod script.

    version2 the above is no longer apllicable. either PS or Rest api has had some changes. 
    #>
    [CmdletBinding()]
    Param ()
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    if (!$mrkApiVersion){
        $global:mrkApiVersion = 'v1'
    }
    Write-Verbose "Get-MrkOrgEndpoint: Meraki RestApi version: $mrkApiVersion"
    #if (!$orgBaseUri){
        # Write-Verbose "Get-MrkOrgEndpoint: global orgBaseUri is empty, retrieving organization specific meraki endpoint"
        # $orgURI = "https://api.meraki.com/api/$mrkApiVersion/organizations"
        # $webRequest = Invoke-WebRequest -uri $orgURI -Method GET -Headers (Get-MrkRestApiHeader)
        # $redirectedURL = $webRequest.BaseResponse.ResponseUri.AbsoluteUri
        # $script:orgBaseUri = $redirectedURL.Replace('/organizations','')
        $script:orgBaseUri = "https://api.meraki.com/api/$mrkApiVersion"
    #}
    Write-Verbose "Get-MrkOrgEndpoint: Meraki RestApi organization URL: $orgBaseUri"
    Return $orgBaseUri
}