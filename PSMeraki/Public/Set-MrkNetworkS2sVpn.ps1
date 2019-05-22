function Set-MrkNetworkS2sVpn{
    <#
    .SYNOPSIS
    Sets the site2site VPN state and which localSubnet to include/exclude in the tunnel.
    .DESCRIPTION
    Sets the site2site VPN state and which localSubnet to include/exclude in the tunnel. The function can
    enable or disable the site-to-site VPN status and set mode hub or spoke as well as set the remote HUB and 
    set the local subnets that should be included in the tunnel or not.
    .EXAMPLE
    Set-MrkNetworkS2sVpn -networkId N_123412341241234 -vpnHubs L_123456789012345678 -mode spoke -useDefaultRoute $false -vpnSubnets "10.20.30.0/24,no","10.20.40.0/24,yes","10.20.50.0/24,yes"
    the above command will enable the site-to-site VPN for network with id N_123412341241234, set the mode to spoke with hub-site-id L_123456789012345678.
    After enabline the spoke mode the script includes the network CIDRs "10.20.40.0/24,yes","10.20.50.0/24,yes" in the VPN-tunnel, but only if that network-id is known as a local subnet.
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    .PARAMETER vpnHubs
    The Meraki id value(s) of the remote hub-site(s) e.g L_123456789012345678.
    This parameter should be provided as a(n array of) string-value(s).
    .PARAMETER mode
    Possible values: none, hub or spoke
    setting none disables the VPN
    setting spoke requires the hubId
    setting hub enables the appliance as VPN hub
    .PARAMETER useDefaultRoute
    Possible values: $true or $false
    Only valid in spoke mode
    .PARAMETER subnets
    This parameter should be provided as a(n array of) string-value(s).
    Each value contains the subnet CIDR and the $true/$false value to set whether a subnet is included in the VPN-tunnel or not/
    Only if the local subnet cidr exists on the appliance the setting will be implemented.
    e.g "10.1.0.0/24,$true","10.1.1.0/24,$false" will include 10.1.0.0/24 in VPN and exclude 10.1.1.0/24. Other vlans are unchanged.
    If $enforce is $true then all local vlan subnets except those mentioned in the subnets are set as excluded from VPN.
    .PARAMETER enforce
    (not used yet)
    #>
    param(
        [Parameter(Mandatory)][String]$networkId,
        [Parameter()][String[]]$vpnHubs,
        [Parameter(Mandatory)][ValidateSet("none", "hub", "spoke")][String]$mode, #none, hub, spoke
        [Parameter()][bool]$useDefaultRoute=$false,
        [Parameter()][String[]]$vpnSubnets,
        [Parameter()][bool]$enforce=$false
    )

    $s2sVpnConfig = Get-MrkNetworkS2sVpn -networkId $networkId

    $hubs = @()
    $subnets = @()

    switch($mode){
        'none' {
            $body = [pscustomobject]@{
                "mode" = $mode
            }
        }
        
        Default {

            ForEach ($hubId in $vpnHubs){
                $hubs += [pscustomobject]@{
                    "hubId" = $hubId
                    "useDefaultRoute" = $false
                }
            }

            #first invoke the rest-call to set the VPN mode; then call the rest-method to retrieve the networks known to meraki for this particular site.
            $body = [pscustomobject]@{
                "mode" = $mode
            }
            if ($mode -eq 'spoke'){
                $body | Add-Member -MemberType NoteProperty -Name "hubs" -value @($hubs)
            }
            $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkID + '/siteToSiteVpn') -body $body

            $localNetworks = (Get-MrkNetworkS2sVpn -networkID $networkID).subnets.localsubnet

            foreach($net in $vpnSubnets){
                #build the $subnets array. $net is constructed like $subnet,$inVpn. e.g: "10.16.48.0/24,yes" or "192.168.128.0/24,no"
                $useVpn = $false

                $netArr = $net -split (",")

                [string]$subnet = $netArr[0]
                $inVpn = ($net -split (","))[1]

                if($inVpn -eq "yes"){$useVpn = $true}

                if($localNetworks.contains($subnet)){
                    $subnets += [pscustomobject]@{
                        "localSubnet" = $subnet
                        "useVpn" = $useVpn
                    }
                }

            }

            #validate the entries in $networkSubnets agains the provided $subnets
            $body = [pscustomobject]@{
                "mode" = $mode
                "hubs" = @($hubs)
                "subnets" = @($subnets)
            }
        }
    }

    $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkID + '/siteToSiteVpn') -body $body

    return $request

}
