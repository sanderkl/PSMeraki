# PSMeraki

This is a PowerShell module around the documented Meraki Rest API functions \([link](https://documenter.getpostman.com/view/897512/meraki-dashboard-api/2To9xm#a5b91474-d9da-c345-cf0e-5c828475686d)\). Only a limited number of meraki rest API functions have been implemented.

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
Get-MrkNetworkS2sVpn
Get-MrkNetworkSiteToSiteVPN
Get-MrkNetworkSSID
Get-MrkNetworkStaticRoute
Get-MrkNetworkVLAN
Get-MrkOrgAdmins
Get-MrkOrganization
Get-MrkOrgEndpoint
Get-MrkSAMLrole
Get-MrkSwitch
Get-MrkTemplate
Get-MrkVPN
New-MrkDevice
New-MrkNetwork
New-MrkOrgAdmin
Remove-MrkDevice
Remove-MrkNetwork
Remove-MrkNetworkVLAN
Remove-MrkOrgAdmin
Set-MrkDevice
Set-MrkNetworkS2sVpn
Set-MrkNetworkSSID
Set-MrkNetworkToTemplate
Set-MrkRestApiKey
Set-MrkSwitchPort
Test-MrkRestApiKey
Update-MrkDevice
Update-MrkNetwork
Update-MrkNetworkMRL3FwRule
Update-MrkNetworkMXL3FwRule
Update-MrkNetworkMXL7FwRule
Update-MrkNetworkVLAN
Update-MrkOrgAdmin
```