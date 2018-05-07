#supportfunctions
function Invoke-MrkRestMethod {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$ResourceID,
        [Parameter(Mandatory)][ValidateSet('GET','POST','PUT','DELETE')][String]$Method,
        [Parameter()][hashtable]$body
    )
    $uri = (Get-MrkOrgEndpoint) + $ResourceID
    try {
        $request = Invoke-RestMethod -Method $Method -ContentType 'application/json' -Headers (Get-MrkRestApiHeader) -Uri $uri -Body ($body|ConvertTo-Json)
    } catch {
        Get-RestError
    }
    return $request
}

function Get-MrkRestApiHeader {
    if (!$mrkRestApiKey){
        Set-MrkRestApiKey 
        Get-MrkRestApiHeader
    } Else {
       $mrkRestApiHeader = @{
        "X-Cisco-Meraki-API-Key" = $mrkRestApiKey
       }
       return $mrkRestApiHeader
    }
} 

function Get-MrkOrgEndpoint {
    $orgURI = 'https://api.meraki.com/api/v0/organizations'
    $webRequest = Invoke-WebRequest -uri $orgURI -Method GET -Headers (Get-MrkRestApiHeader)
    $redirectedURL = $webRequest.BaseResponse.ResponseUri.AbsoluteUri
    $redirectedURLBase = $redirectedURL.Replace('/organizations','')
    Return $redirectedURLBase
}

function Set-MrkRestApiKey {
    <#
    .SYNOPSIS
    Sets a Meraki Rest API key for a powershell session
    .DESCRIPTION
    REST API key is unique for each Meraki dashboard user. the REST API should be enabled organization wide, a dashboard user is able to create a key
    more info https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API
    .EXAMPLE
    Get-MrkNetwork 
    .EXAMPLE
    Get-MrkNetwork 1234567890abcdefabcd1234567890abcdefabcd
    .PARAMETER key
    40 characters 0-9 a-f key that represents a logged in Meraki dashboard user 
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [String]$key
    )
    if (!$mrkRestApiKey){
        $script:mrkRestApiKey = (Read-host Enter Meraki REST API key).Trim()
        Write-Host Key set`, to change the key in this session`, use  Set-MrkRestApiKey `<key`>    
    } 
    if ($key){
        $script:mrkRestApiKey = $key
        Write-Host New Key set
    }
    if (!(Test-MrkRestApiKey -apiKey $mrkRestApiKey)){
        Write-Host REST API Key is invalid
        break
    }
    
   
} 

function Test-MrkRestApiKey {
    [CmdletBinding()]
    [OutputType([bool])]

    Param (
        [Parameter()][string]$apiKey
    )
    if ($apiKey.Length -ne 40){
        Write-Output "key length is not 40 bytes`, aborting.."
        break 
    }
    return $true
} 

function Get-RestError {
    Write-Output "PS Error: $_.Exception.Message"
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $responseBody = $reader.ReadToEnd();
    Write-Output "REST Error: $responsebody"
}

#Meraki functions
function Get-MrkOrganization {
    <#
    .SYNOPSIS
    Retrieves all Organizations the apikey has access to 
    .EXAMPLE
    Get-MrkOrganization
    #>
    $request = Invoke-MrkRestMethod -Method GET -ResourceID '/organizations'
    return $request
}

function Get-MrkFirstOrgID {
  <#
  .SYNOPSIS
  This function returns the first organization ID (a number) from the list that is produced by Get-MrkOrganizations
  .DESCRIPTION
  This Function is called if the organization is not specified for a function that requires an OrgId. in those functions it can be specified using parameter -OrgId. 
  for example function Get-MrkNetworks uses this fuinction to automatically get an OrgId 
  .EXAMPLE
  Get-MrkFirstOrgID
  #>
    $MrkOrg = Get-MrkOrganization
    if ($MrkOrg){
        return $MrkOrg[0].id 
    } Else {
        Write-Output "no meraki organizations found is api correct? use Set-MrkRestApiKey `<key`>"
    }
}

function Get-MrkNetwork {
    <#
    .SYNOPSIS
    Retrieves all meraki networks for an organization
    .DESCRIPTION
    Describe the function in more detail
    .EXAMPLE
    Get-MrkNetwork 
    .EXAMPLE
    Get-MrkNetwork -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/networks')
    return $request
}

function Get-MrkTemplate {
    <#
    .SYNOPSIS
    Retrieves all Meraki templates for an organization
    .DESCRIPTION
    Gets a list of all Meraki templates configured in an organization. 
    .EXAMPLE
    Get-MrkTemplate 
    .EXAMPLE
    Get-MrkTemplate -OrgId 111222
    .PARAMETER OrgId
    optional specify a org Id, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/configTemplates')
    return $request
}

function Get-MrkVPN {
    <#
    .SYNOPSIS
    Retrieves all VPNs for a Meraki Organization
    .DESCRIPTION
    Gets a list of all VPNs for a Meraki organization. 
    .EXAMPLE
    Get-MrkVPN
    .EXAMPLE
    Get-MrkVPN -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/thirdPartyVPNPeers')
    return $request
}

function Get-MrkDevicesStatus {
    <#
    .SYNOPSIS
    Retrieves all VPNs for a Meraki Organization
    .DESCRIPTION
    Gets a list of all VPNs for a Meraki organization. 
    .EXAMPLE
    Get-MrkVPN
    .EXAMPLE
    Get-MrkVPN -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/deviceStatuses')
    return $request
}

function Get-MrkSAMLrole {
    <#
    .SYNOPSIS
    Retrieves all SAML roles for a Meraki Organization
    .DESCRIPTION
    Gets a list of all SAML roles for a Meraki organization. 
    .EXAMPLE
    Get-MrkSAMLrole
    .EXAMPLE
    Get-MrkSAMLrole -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/samlRoles')
    return $request
}

function Get-MrkLicenseState {
    <#
    .SYNOPSIS
    Retrieves Licence state for a Meraki Organization
    .EXAMPLE
    Get-MrkLicenseState
    .EXAMPLE
    Get-MrkLicenseState -OrgId 111222
    .PARAMETER OrgId
    optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    #>
    [CmdletBinding()]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID)
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/organizations/' + $OrgId + '/licenseState')
    return $request
}

function Get-MrkSwitch {
    <#
    .SYNOPSIS
    Retrieves all meraki switches for a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki switches in a Meraki network. 
    .EXAMPLE
    Get-MrkSwitches 
    .EXAMPLE
    Get-MrkSwitches -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/devices')
    return $request
}

function Get-MrkNetworkGroupPolicy {
    <#
    .SYNOPSIS
    Retrieves all group policies for a Meraki network
    .DESCRIPTION
    Gets a list of all group policies in a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkGroupPolicy -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/groupPolicies')
    return $request
}

function Get-MrkNetworkDevice {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network Devices on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network Devices on a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkDevice -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/devices')
    return $request
}

function Get-MrkNetworkSSID {
    <#
    .SYNOPSIS
    Retrieves all Meraki SSIDs on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki SSIDs on a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkSSID -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/ssids')
    return $request
}

function Get-MrkNetworkRoute {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network Routes on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network Routes on a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkRoute -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/staticRoutes')
    return $request
}

function Get-MrkNetworkVLAN {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network VLANs on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network VLANs on a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkVLAN -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/vlans')
    return $request
}

function Get-MrkNetworkSiteToSiteVPN {
    <#
    .SYNOPSIS
    Retrieves all Meraki Network SiteToSiteVPNs on a Meraki network
    .DESCRIPTION
    Gets a list of all Meraki Network SiteToSiteVPNs on a Meraki network. 
    .EXAMPLE
    Get-MrkNetworkSiteToSiteVPN -networkID X_112233445566778899
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkID + '/siteToSiteVpn')
    return $request
}

function Get-MrkDeviceClient {
    <#
    .SYNOPSIS
    Retrieves all clients connected to a Meraki device
    .DESCRIPTION
    Gets a list of all Clients connected to a Meraki device. 
    .EXAMPLE
    Get-MrkDeviceClient -DeviceSerial Q2XX-XXXX-XXXX
    .PARAMETER DeviceSerial
    specify a DeviceSerial, find a serial number using Get-MrkNetworkDevices
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$DeviceSerial
    )
    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/devices/' + $networkID + '/clients?timespan=84000')
    return $request
}

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
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter()][String]$OrgId = (Get-MrkFirstOrgID),
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory)][ValidateSet('wireless','switch','appliance','phone','combined')][String]$Type,
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

function Set-MrkNetworkToTemplate {
    <#
    .SYNOPSIS
    binds a network to a Template
    .EXAMPLE
    Set-MrkNetworkToTemplate -networkID X_112233445566778899 -TemplateId Z_998877445566778899
    .PARAMETER networkID 
    specify a networkID, find an id using get-MrkNetworks
    .PARAMETER TemplateId 
    specify a templateID, find an id using get-MrkTemplates
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$templateID
    )
    $body  = @{
        "configTemplateId" = $templateID
        "autoBind" = $false
    }
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $networkID + '/bind') -Body $body  
    return $request
}

function New-MrkDevice {
    <#
    .SYNOPSIS
    Adds (claims) a new device, adds it to a network
    .DESCRIPTION
    blah 
    .EXAMPLE
    New-MerakiDevice -Networkid X_111122223639801111 -Serial Q2XX-XXXX-XXXX
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER SerialNr 
    Serial number of the physical device that is added to the network. 
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$SerialNr
    )
    $body = @{
        "serial"=$SerialNr
    }
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $Networkid + '/devices/claim') -Body $body  
    return $request
}

function Update-MrkDevice {
    <#
    .SYNOPSIS
    Adds (claims) a new device, adds it to a network
    .DESCRIPTION
    blah 
    .EXAMPLE
    Update-MrkDevice -Networkid X_111122223639801111 -SerialNr Q2XX-XXXX-XXXX -NewName TestName -NewTags TestTag -NewAddress "Kalverstraat, Amsterdam" 
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER SerialNr 
    Serial number of the physical device that is added to the network. 
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$SerialNr,
        [Parameter()][String]$NewName,
        [Parameter()][String]$NewTags,
        [Parameter()][String]$NewAddress
    )
    $body = @{
        "name"=$Name
        "tags"=$Tags
        "address"=$Address
    }
    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $Networkid + '/devices/' + $SerialNr) -Body $body  
    return $request
}

function Remove-MrkDevice {
    <#
    .SYNOPSIS
    Removes a new device, adds it to a network
    .DESCRIPTION
    blah 
    .EXAMPLE
    Remove-MrkDevice -Networkid X_111122223639801111 -Serial Q2XX-XXXX-XXXX
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER SerialNr 
    Serial number of the physical device that is added to the network. 
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$SerialNr
    )
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $Networkid + '/devices/' + $SerialNr + '/remove')
    return $request
}

function Add-MrkNetworkVLAN { # UNTESTED
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the Network ID, to find an id use get-MrkNetwork
    .EXAMPLE
    Add-MrkNetworkVLAN -Networkid X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0 -applianceIP 10.11.12.254
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER id
    VLAN is, a number between 1 and 4094
    .PARAMETER Name
    The Name of the new VLAN
    .PARAMETER subnet
    The subnet of the VLAN 
    .PARAMETER applianceIP
    The local IP of the appliance on the VLAN 
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Id,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Subnet,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$applicanceIP
    )
    $body  = @{
        "id" = $Id
        "networkId" = $Networkid
        "name" = $Name
        "applianceIp" = $applicanceIP
        "subnet" = $Subnet
    }
    $request = Invoke-MrkRestMethod -Method POST -ResourceID ('/networks/' + $Networkid + '/vlans') -Body $body  
    return $request
}

function Update-MrkNetworkVLAN { # UNTESTED
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the Network ID, to find an id use get-MrkNetwork
    .EXAMPLE
    Add-MrkNetworkVLAN -Networkid X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0 -applianceIP 10.11.12.254
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER id
    VLAN is, a number between 1 and 4094
    .PARAMETER Name
    The Name of the new VLAN
    .PARAMETER subnet
    The subnet of the VLAN 
    .PARAMETER applianceIP
    The local IP of the appliance on the VLAN 
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Id,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Subnet,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$applicanceIP
    )
    $body  = @{
        "id" = $Id
        "networkId" = $Networkid
        "name" = $Name
        "applianceIp" = $applicanceIP
        "subnet" = $Subnet
    }
    $request = Invoke-MrkRestMethod -Method Put -ResourceID ('/networks/' + $Networkid + '/vlans/' + $Id) -Body $body  
    return $request
}

function Remove-MrkNetworkVLAN { # UNTESTED
    <#
    .SYNOPSIS
    Adds a VLAN to a Meraki network
    .DESCRIPTION
    Adds a VLAN to a Meraki network, identifying the network with the Network ID, to find an id use get-MrkNetwork
    .EXAMPLE
    Add-MrkNetworkVLAN -Networkid X_111122223639801111 -id 500 -Name DATA -subnet 10.11.12.0 -applianceIP 10.11.12.254
    .PARAMETER Networkid 
    id of a network (get-MrkNetworks)[0].id
    .PARAMETER id
    VLAN is, a number between 1 and 4094
    .PARAMETER Name
    The Name of the new VLAN
    .PARAMETER subnet
    The subnet of the VLAN 
    .PARAMETER applianceIP
    The local IP of the appliance on the VLAN 
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Networkid,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$Id
    )
    $request = Invoke-MrkRestMethod -Method DELETE -ResourceID ('/networks/' + $Networkid + '/vlans/' + $Id)
    return $request
}

Write-Host Meraki Module loaded`, to list all commands use: Get-Command `-Module Meraki `- Sander Klaassen May2018