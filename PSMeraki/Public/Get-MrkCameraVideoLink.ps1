function Get-MrkCameraVideoLink {
    <#
    .SYNOPSIS
    Returns video link for the specified camera
    .DESCRIPTION
    .EXAMPLE
    Get-MrkCameraVideoLink -Serial XXXX-XXXX-XXXX
    .PARAMETER serial
    Serial number for the camera.
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