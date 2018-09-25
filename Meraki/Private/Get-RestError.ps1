function Get-RestError {
    Write-Output "PS Error: $_.Exception.Message"
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $responseBody = $reader.ReadToEnd();
    Write-Output "REST Error: $responsebody"
}