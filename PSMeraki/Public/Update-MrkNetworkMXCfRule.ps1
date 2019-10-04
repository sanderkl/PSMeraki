Function Update-MrkNetworkMXCfRule{
    <#
    UNDER CONSTRUCTION
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .PARAMETER networkId

    .PARAMETER action

    .PARAMETER reset

    .PARAMETER allowedUrlPatterns

    .PARAMETER blockedUrlPatterns

    .PARAMETER blockedUrlCategories

    .PARAMETER urlCategoryListSize

    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$networkId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("add", "remove")]
        [String]$action,

        [Parameter()]
        [switch]$reset
    )
}