# PSMeraki

This is a PowerShell module for Cisco Meraki REST API \([documentation](https://developer.cisco.com/meraki/api-v1/#!overview)\). 
Not all avaiable Meraki REST API functions are included in this module.

New in v2.0.1 (NOVEMBER 2021):

- Reboot-Device fixed, now is a POST request (thanks @andrewzirkel)
- Added missing public functions. (thanks @StingzLD)
- Updated Cisco Meraki REST API documentation link. 

New in v2.0 (JUNE 2021):

- Module now uses v1 endpoint (Can be switched back using set-mrkRestApiVersion -version v0 for backward compatibility)
- Inaddition to version Powershell 5.1 also tested on PowerShell and 7 under Windows and Linux. 
- Fixed an issue where the module threw an error when a mrk cmdlet was used without a setting an apikey first. 
- Removed a workaround for redirects sent by meraki which powershell was unable to handle.
- Moved Invoke-MrkRestMethod to public cmdlets to allow more flexibility. When a resource is missing in the existing cmdlets this cmdlet can be used to call the missing resource.  
- Added Restart-MrkDevice

New in v1.1 (MAY 2019):

- Added cmdlts to configure Layer 3 & 7 Firewall rules 
- Added cmdlts to configure Site to Site VPN.
- Fixed various bugs

## Install

Download and install the module from PSGallery:

```powershell
Install-Module -Name PSMeraki
```

OR

Download and extract the zip file.

Copy 'PSmeraki' directory to a module path.
These are the default values for PSModulepath:

- C:\Users\\-username-\Documents\WindowsPowerShell\Modules;
- C:\Program Files\WindowsPowerShell\Modules;
- C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules

Type in powershell:

`Import-Module PSMeraki`

running `Get-mrkNetwork` will ask for a Meraki API key.

Two things have to be configured in the Meraki dashboard:

1. Enable Rest API access, organization wide
2. Create Rest API key, for a dashboard user

Login to [the Meraki dashboard](https://account.meraki.com/secure/login/dashboard_login)

## Enable Rest API Access for the organization

API key has to be organization wide enabled, to do that, go to organization settings

![Image Meraki dashboard](https://imgur.com/LBzIhK3.png)

Scroll down to 'Dashboard API access' and tick the box to enable it.

![Image Meraki dashboard](https://imgur.com/iOXTiEJ.png)

## Create API key for your user

Go to profile settings

![Image Meraki dashboard profile link](https://imgur.com/ymjzujI.png)

In your profile, scroll down to 'API access'

![Image Meraki dashboard new API key](https://imgur.com/Dbux0J5.png)

Generate a new rest api key, its a 40 byte key.
Either remember it or store it in a safe location, this code represents your logged in Meraki dashboard user.
This is the 'rest api key' the module asks for.

## cmdlets

This module includes the following cmdlets:

```powershell
Add-MrkNetworkStaticRoute
Add-MrkNetworkVLAN
Get-MrkCameraVideoLink
Get-MrkDevice
Get-MrkDeviceClient
Get-MrkDeviceGroupPolicy
Get-MrkDevicesStatus
Get-MrkInventory
Get-MrkLicenses
Get-MrkLicenseState
Get-MrkNetwork
Get-MrkNetworkBluetoothClient
Get-MrkNetworkDevice
Get-MrkNetworkGroupPolicy
Get-MrkNetworkMRL3FwRule
Get-MrkNetworkMxCfRule
Get-MrkNetworkMXL3FwRule
Get-MrkNetworkMXL7FwRule
Get-MrkNetworkRoute
Get-MrkNetworkSiteToSiteVPN
Get-MrkNetworkSSID
Get-MrkNetworkStaticRoute
Get-MrkNetworkVLAN
Get-MrkOrgAdmins
Get-MrkOrganization
Get-MrkOrgEndpoint
Get-MrkRestApiVersion
Get-MrkSAMLrole
Get-MrkSwitch
Get-MrkTemplate
Get-MrkTemplateNetworks
Get-MrkVPN
Invoke-MrkRestMethod
New-MrkDevice
New-MrkNetwork
New-MrkOrgAdmin
Remove-MrkDevice
Remove-MrkNetwork
Remove-MrkNetworkTemplate
Remove-MrkNetworkVLAN
Remove-MrkOrgAdmin
Restart-MrkDevice
Set-MrkDevice
Set-MrkNetworkSiteToSiteVPN
Set-MrkNetworkSSID
Set-MrkNetworkToTemplate
Set-MrkRestApiKey
Set-MrkRestApiVersion
Set-MrkSwitchPort
Update-MrkDevice
Update-MrkNetwork
Update-MrkNetworkMRL3FwRule
Update-MrkNetworkMXL3FwRule
Update-MrkNetworkMXL7FwRule
Update-MrkNetworkVLAN
Update-MrkOrgAdmin
```