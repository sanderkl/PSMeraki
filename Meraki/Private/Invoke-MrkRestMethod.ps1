function Invoke-MrkRestMethod {
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