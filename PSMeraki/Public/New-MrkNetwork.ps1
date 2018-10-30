function New-MrkNetwork {
    <#
    .SYNOPSIS
    Creates a new network in Merkai Org 
    .DESCRIPTION
    blah 
    .EXAMPLE
    New-MrkNetwork -Name Loc321 -Type wireless -Tags adsl -TimeZone "Europe/Amsterdam" 
    .EXAMPLE
    New-MrkNetwork -Name Loc321 -Type wireless -Tags adsl -TimeZone "Europe/Amsterdam" -OrgId 111111
    .PARAMETER Name 
    Name of the new network
    .PARAMETER Type 
    Network type can be one of these: 'wireless','switch','appliance','phone','combined'
    .PARAMETER Tags
    optional tags for the network
    .PARAMETER Timezone
    define timezone where network is located, names can be found 'TZ*' column on https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    .PARAMETER OrgID
    optional parameter is a decimal number representing your organization. if this parameter is not specified it will use Get-MrkFirstOrgID to retreive the organization number
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory)][ValidateSet('wireless','switch','appliance','phone','appliance switch wireless')][String]$Type,
        [Parameter(Mandatory)][String]$TimeZone,
        [Parameter()][String]$Tags
    )
    $body  = @{
        "name" = $Name
        "type" = $type
        "tags" = $tags
        "timeZone" = $TimeZone
    }
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/organizations/' + $OrgId + '/networks') -Body $body  
    return $request
}