$PSMerakiCMDLets = Get-Command -Module 'PSmeraki'
if (Get-Module -Name PSMeraki){
    Remove-Module PSmeraki
}
if ($PSMerakiCMDLets){
    foreach ($cmdLet in $PSMerakiCMDLets){
        $Path = 'Function:\' + $cmdLet.Name
        Remove-Item -Path $Path
    }
    Write-Host Cmdlets removed
} Else {
    Write-Host No cmdlets to remove
}