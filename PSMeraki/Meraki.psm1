[CmdletBinding()]
Param ()
#Get public and private function definition files.
Write-Verbose "VOConfigVM Module: script root $PSScriptRoot"
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse)
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse)

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
        Write-Verbose "VOConfigVM Module: Imported $import.fullname"
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename