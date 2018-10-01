function Get-MrkCameraVideoLink {
    <#
    .SYNOPSIS
    Returns video link for the specified camera
    .DESCRIPTION
    .EXAMPLE
    Get-MrkCameraVideoLink -Serial 2345erty2345
    .NOTES
    This function Untested
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$serial
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/devices/' + $Serial + '/cameras/video_link')
    return $request
}