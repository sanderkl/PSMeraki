function Update-MrkNetworkMXL7FwRule{
    <#
    .SYNOPSIS
    Adds a Meraki L7 Firewall rule to the given Meraki network.
    .DESCRIPTION
    Adds a Meraki L7 Firewall rule to the given Meraki network. 
    For MX series the firewall rules are set per NetworkID.
        PUT {{baseUrl}}/networks/{networkId}/l7FirewallRules
    .EXAMPLE
    Update-MrkNetworkMXL7FwRule -networkId X_112233445566778899 -policy Deny -type applicationCategory -value 
    Update-MrkNetworkMXL7FwRule -networkId X_112233445566778899 -policy Deny -type host -value malicious.domain.com 
    .PARAMETER networkId
    specify a networkId, find an id using get-MrkNetworks
    .PARAMETER policy
    This parameter is currently only available as 'deny' and determines if the rule is to deny (or allow?) a certain L7 destination
    .PARAMETER type
    This parameter is a fixed ValidateSet: "application", "applicationCategory","host","port","ipRange"
    * application(Category): this type requires a value of type array that provides an id and name of the Meraki-defined list of applications
    * host: this type requires a value of type string that names the host. E.g. www.somedomain.com
    * port: this type requires a value of type string that contains the portnumber that should be blocked
    * ipRange: this type requires a value of type string that contains the iprange (ip4v) that should be blocked
    .PARAMETER value
    the value is either a string or an array depending on the rule-type
    the array-value must be given like this: @{id="meraki:layer7/category/13";name="Video & music"}
    .PARAMETER action
    the action is add or remove. 'add' will look in the list of existing rules and only add the provided rule if not present yet.
    'remove' will look in the list of existing rules and only remove it when it is present.
    .PARAMETER reset
    optional switch to determine if the cmdlet will keep the existing L3 Firewall rules or start with a clean set of rules and add only this new one.
    not specifying it or assigning $false will keep the existing rules (default).
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId,
        [ValidateSet("deny")][String]$policy="deny",
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet("application", "applicationCategory","host","port","ipRange")][String]$type,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()]$value,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateSet("add", "remove")][String]$action,
        [Parameter()][switch]$reset
    )

    $ruleset = @()
    if (-not $reset){
        $ruleset = (Get-MrkNetworkMXL7FwRule -networkId $networkId).rules
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

        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkId + '/l7FirewallRules') -body $ruleObject
        return $request

        # construct the uri of the MR device in the current organization
        # $uri = "$(Get-MrkOrgEndpoint)/networks/$networkId/l7FirewallRules"    
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

