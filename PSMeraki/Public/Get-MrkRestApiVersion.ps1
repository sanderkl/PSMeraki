function Get-MrkRestApiVersion {
    <#
    .SYNOPSIS
    Shows current Meraki Rest API endpoint version. 
    Currently its either V0 or V1, wherre V1 is the default set by the script itself. 
    This can be overwritten by using: set-MrkRestApiVersion -Version v0
    .EXAMPLE 
    Get-MrkRestApiVersion 
    #>
    [CmdletBinding()]
    Param ()
    if (!$mrkApiVersion){
        $global:mrkApiVersion = 'v1'
    }
    $mrkApiVersion
}