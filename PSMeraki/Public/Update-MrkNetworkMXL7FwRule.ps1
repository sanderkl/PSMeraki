function Update-MrkNetworkMXL7FwRule{
    <#
    .SYNOPSIS
    Adds a Meraki L7 Firewall rule to the given Meraki network.
    .DESCRIPTION
    Adds a Meraki L7 Firewall rule to the given Meraki network. 
    For MX series the firewall rules are set per NetworkID.
        PUT {{baseUrl}}/networks/{networkId}/l7FirewallRules
    .EXAMPLE
    Add-MrkNetworkMXL7FwRule -networkID X_112233445566778899 -policy Deny -type applicationCategory -value
    .PARAMETER networkID
    specify a networkID, find an id using get-MrkNetworks
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID,
        [ValidateSet("deny")][String]$policy="deny",
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet("application", "applicationCategory","host","port","ipRange")][String]$type,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()]$value,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet("add", "remove")][String]$action,
        [Parameter()][switch]$reset
    )
    Update-MrkNetworkMXL7FwRule -networkId $CWCLNW.id -action add -policy deny -type applicationCategory -value @{id="meraki:layer7/category/13";name="Video & music"} -reset

    $ruleset = @()
    if (-not $reset){
        $ruleset = (Get-MrkNetworkMXL7FwRule -networkID $networkId).rules
    }
    #the value in the rule-object is an object itself that cannot be compared as string
    if ($type -match "application"){
        $PSoValue = [pscustomobject]$value
    } else {
        $PSoValue = $value
    }

    #populate the to-be ruleset first with the existing rules (will be empty in case of reset)
    $applyRules = @()
    ForEach ($rule in $ruleset){

        #if the action is delete and the rule specifications policy/type/value are equal do not add it back to the ruleset. 
        if ($action -eq 'remove' -and `
           ($rule.policy -eq $policy -and `
            $rule.type -eq $type -and `
            $rule.value -match $PSoValue)){
                "No longer adding this rule: $value";
                continue
            }

        if ($action -eq 'add' -and `
            ($rule.policy -eq $policy -and `
             $rule.type -eq $type -and `
             $rule.value -match $PSoValue)){
                  "Not adding new rule as it is already present: $value";
                  $rulePresent = $true
              }
          
        #add this exising rule into the $ruleset object
        $ruleEntry = [PSCustomObject]@{
            policy = $rule.policy
            type   = $rule.type
            value  = $rule.value
        }

        $applyRules += $ruleEntry

    }

    #append the new ruleobject to the applyRules
    if ($action -eq 'add' -and $true -ne $rulePresent){
        $ruleEntry = New-Object -TypeName PSObject -Property @{
            policy = $policy
            type   = $type
            value  = $PSoValue
        }

        $applyRules += $ruleEntry
    };

    #construct the full ruleObject to push into the $body of the RESTapi request
    $ruleObject = New-Object -TypeName PSObject -Property @{
        rules = $applyRules
    }

    if($true -ne $rulePresent){

        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkID + '/l7FirewallRules') -body $ruleObject
        return $request

        # construct the uri of the MR device in the current organization
        # $uri = "$(Get-MrkOrgEndpoint)/networks/$networkID/l7FirewallRules"    
        # try {
        #     $request = Invoke-RestMethod -Method Put `
        #     -ContentType 'application/json' `
        #     -Headers (Get-MrkRestApiHeader) `
        #     -Uri $uri `
        #     -Body ($ruleObject | ConvertTo-Json -Depth 4) -Verbose -ErrorAction Stop

        #     Write-Host "succesfully updated firewall rules" -ForegroundColor Green
        # }
        # catch
        # {
        #     $_.exception
        # }

        # Return ($request | ConvertTo-Json)

    }
}

