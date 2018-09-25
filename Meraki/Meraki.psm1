# New-ModuleManifest -RootModule 'Meraki.psm1' -Author 'Sander Klaassen' -CompanyName 'Qonnect' -Description 'Meraki PowerShell module' -Path 'C:\Users\Administrator\Documents\VesselDeploy20180920\Scripts\_PSModules\Meraki\Meraki.psd1'
[CmdletBinding()]
Param ()
#Get public and private function definition files.
Write-Verbose "VOConfigVM Module: script root $PSScriptRoot"
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\ -Filter *.ps1 -Recurse)
#$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\ -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

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