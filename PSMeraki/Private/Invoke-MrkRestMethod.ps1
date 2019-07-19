function Invoke-MrkRestMethod {
    <#
    .SYNOPSIS
        This function is called by all public functions in the PSMeraki module.
        Collects all needed parts to create a rest api call then invokes it and returns the result.
    .DESCRIPTION
        This function invokes the generik invoke-restmethod using the provided methods and body data.
        Meraki REST API calls are restricted on an organization level to max 5 per second. In case the rate is exceeded this error is in the try/catch with http errormessage
        'The remote server returned an error: (429) Too Many Requests.' This is a MUI specific error with generic (429) returncode. that (429) is matched using REGEX to be language independent.
    .EXAMPLE
        Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/networks')
    .PARAMETER ResourceID 
        is the last part of the api uri describing the actual resource for the REST call,
    .PARAMETER Method
        can be GET, POST, PUT or DELETE dpeends on the api function that is called. 
    .PARAMETER body
        some api functions require more input, this parameter expects an object that can convert to JSON. It can be a hashtable or PSCustomObject type. 
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$ResourceID,
        [Parameter(Mandatory)][ValidateSet('GET','POST','PUT','DELETE')][String]$Method,
        [Parameter()]$body
    )
    $orgBaseUri = Get-MrkOrgEndpoint
    $uri = $orgBaseUri + $ResourceID
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    try {
        $request = Invoke-RestMethod -Method $Method -ContentType 'application/json' -Headers (Get-MrkRestApiHeader) -Uri $uri -Body ($body | ConvertTo-Json -Depth 10)
    } catch {
        if ($_.exception.message -match [regex]::Escape('(429)')){
            Write-Verbose "Meraki reports 'Too many API Rquests', sleeping 1 second and rerunning the same request"
            Start-Sleep 1
             $request = Invoke-RestMethod -Method $Method -ContentType 'application/json' -Headers (Get-MrkRestApiHeader) -Uri $uri -Body ($body | ConvertTo-Json -Depth 10)
            # Invoke-MrkRestMethod -ResourceID $ResourceID -Method $method -body $body;
        } elseif ($_.exception.message -match [regex]::Escape('(308)')){
             Write-Verbose "Meraki reports redirection. Request the orgBaseUri and rerun the same request"
             Get-MrkOrgEndpoint # reset the $global:orgBaseUri variable to get the non-default api.meraki.com URI
             $uri = $global:orgBaseUri + $ResourceID
             $request = Invoke-RestMethod -Method $Method -ContentType 'application/json' -Headers (Get-MrkRestApiHeader) -Uri $uri -Body ($body | ConvertTo-Json -Depth 10)
             # Invoke-MrkRestMethod -ResourceID $ResourceID -Method $method -body $body;
        } else {
            Get-RestError
        }
    }
    return $request
}
