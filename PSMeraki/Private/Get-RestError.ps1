function Get-RestError {
    <#
    .SYNOPSIS
    Internal function that is triggered in a "Catch" frion a Try/Catch routine, it displays the HTTP and REST error seperately. 
    Error handing changed in PS core, so this is proccessed seperately. 
    #>
    [CmdletBinding()]
    Param ()
    #PowerShell 5.x
    if ($PSVersionTable.PSVersion.Major -lt '6'){
        Write-Output "HTTP Error: $_.Exception.Message"
        if ($_.Exception.Response){
            $result = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result)
            $responseBody = $reader.ReadToEnd();
            $RestApiErroDescription = ($responseBody | ConvertFrom-Json).errors
            Write-Output "REST Error: $RestApiErroDescription"
        }
    } Else { #PowerShell 6+
        $ResponseCode = $_.Exception.Response.StatusCode.value__
        $ResponseReasonPhrase = $_.Exception.Response.ReasonPhrase
        Write-Output "HTTP Response: $ResponseCode $ResponseReasonPhrase"
        if (Test-Json -Json ($_.ErrorDetails).Message -ErrorAction SilentlyContinue){
            $RestApiErroDescription = (($_.ErrorDetails).Message | ConvertFrom-Json).errors
        } Else {
            $RestApiErroDescription = ($_.ErrorDetails).Message 
        }
        Write-Output "REST Error: $RestApiErroDescription"
    }
}