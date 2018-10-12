function Invoke-MrkRestMethod {
    <#
    .SYNOPSIS
    This function is called by all public functions in the PSMeraki module.
    Collects all needed parts to create a rest api call then invokes it and returns the result.
    .DESCRIPTION
    .EXAMPLE
    Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/networks')
    .PARAMETER ResourceID 
    is the last part of the api uri,
    .PARAMETER Method
    can be GET, POST, PUT or DELETE dpeends on the api function that is called. 
    .PARAMETER body
    some api function require more input, this parameter expects a hash table. 
    #>    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$ResourceID,
        [Parameter(Mandatory)][ValidateSet('GET','POST','PUT','DELETE')][String]$Method,
        [Parameter()][hashtable]$body
    )
    $uri = (Get-MrkOrgEndpoint) + $ResourceID
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    try {
        $request = Invoke-RestMethod -Method $Method -ContentType 'application/json' -Headers (Get-MrkRestApiHeader) -Uri $uri -Body ($body|ConvertTo-Json)
    } catch {
        Get-RestError
    }
    return $request
}