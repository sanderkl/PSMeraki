function Get-MrkOrgEndpoint {
    <#
    .DESCRIPTION
    PowerShell cmdlet has trouble with the redirectoion meraki uses, from api.meraki.com to the organization specific url ( such as n210.meraki.com).
    To work around this issue this function retrieves the oranization specific URL and uses it through out the module functions.
    The global variable orgBaseUri is set here and used in the invoke restmethod script.
    #>
    [CmdletBinding()]
    Param ()
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    if (!$orgBaseUri){
        Write-Verbose "Get-MrkOrgEndpoint: global orgBaseUri is empty, retrieving organization specific meraki endpoint"
        $orgURI = 'https://api.meraki.com/api/v0/organizations'
        $webRequest = Invoke-WebRequest -uri $orgURI -Method GET -Headers (Get-MrkRestApiHeader)
        $redirectedURL = $webRequest.BaseResponse.ResponseUri.AbsoluteUri
        $global:orgBaseUri = $redirectedURL.Replace('/organizations','')
    }
    Write-Verbose "Get-MrkOrgEndpoint: Meraki RestApi organization URL: $orgBaseUri"
    Return $orgBaseUri
}