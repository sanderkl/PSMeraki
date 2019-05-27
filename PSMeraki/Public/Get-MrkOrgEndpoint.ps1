function Get-MrkOrgEndpoint {
    <#
    .DESCRIPTION
    PowerShell cmdlet has trouble with the redirectoion meraki uses, from api.meraki.com to the organization specific url ( such as n210.meraki.com).
    To work around this issue this function retrieves the oranization specific URL and uses it through out the module functions.
    The global variable orgBaseUri is set here and used in the invoke restmethod script.
    #>
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $orgURI = 'https://api.meraki.com/api/v0/organizations'
    $webRequest = Invoke-WebRequest -uri $orgURI -Method GET -Headers (Get-MrkRestApiHeader)
    $redirectedURL = $webRequest.BaseResponse.ResponseUri.AbsoluteUri
    $redirectedURLBase = $redirectedURL.Replace('/organizations','')
    $global:orgBaseUri = $redirectedURLBase
    Write-Verbose "Meraki RestApi organization URL: $orgBaseUri"
    Return $redirectedURLBase
}