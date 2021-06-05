function Restart-MrkDevice {
    <#
    .SYNOPSIS
    Reboots a Meraki device based on serial number
    .DESCRIPTION
    Reboots a Meraki device based on serial number
    .EXAMPLE
    Reboot-MrkDevice -Serial Q2PN-AB12-V3X6
    .EXAMPLE
    Reboot-MrkDevice -Serial Q2PN-AB12-V3X6
    .PARAMETER serial
    the serialnumber as mentioned on the Meraki device label.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][String]$Serial,
        [Parameter()][ValidateNotNullOrEmpty()][String]$networkId
    )
    if ($mrkApiVersion -eq 'v0'){
        Invoke-MrkRestMethod -Method GET -ResourceID "/networks/$networkId/devices/$Serial/reboot"
    } Else { #mrkApiVersion v1
        Invoke-MrkRestMethod -Method GET -ResourceID "/devices/$Serial/reboot"
    }
}