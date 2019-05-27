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
    .PARAMETER name 
    Name of the new network
    .PARAMETER type 
    Network type can be one of these: 'wireless','switch','appliance','phone'
    Once you create a network of type 'appliance' and at a later stage add/claim different device-types the network type dynamically changes to 'combined'
    .PARAMETER tags
    optional tags for the network
    .PARAMETER timeZone
    define timezone where network is located, names can be found 'TZ*' column on https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    .PARAMETER orgId
    optional parameter is a decimal number representing your organization. if this parameter is not specified it will use Get-MrkFirstOrgID to retreive the organization number
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$orgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$name,
        [Parameter(Mandatory)][ValidateSet('wireless','switch','appliance','phone')][String[]]$type,
        [Parameter(Mandatory)][String]$TimeZone,
        [Parameter()][String]$Tags
    )
    $body  = @{
        "name" = $name
        "type" = $type -join (" ")
        "tags" = $tags
        "timeZone" = $timeZone
    }
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/organizations/' + $orgId + '/networks') -Body $body  
    return $request
}