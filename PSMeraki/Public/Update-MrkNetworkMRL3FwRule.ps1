function Update-MrkNetworkMRL3FirewallRules {
    <#
    .SYNOPSIS
        Retrieves all Meraki L3 Firewall for a given Meraki network/ssid.
        Adds the newly provided rule to the top of the list.
    .DESCRIPTION
        Retrieves all Meraki L3 Firewall for a given Meraki network/ssid.
        Adds the newly provided rule to the top of the list.
    .EXAMPLE
        Update-MrkNetworkMRL3FirewallRules -networkID X_112233445566778899
    .PARAMETER networkID
        specify a networkID, find an id using get-MrkNetworks
    .PARAMETER ssidID
        specify the integer Id value of the SSID entry to modify
    .PARAMETER comment
        specify the rule comment to describe the rule purpose
    .PARAMETER policy
        specify 'deny' or 'allow'
    .PARAMETER protocol
        specify the protocol 'any', 'tcp' or 'udp'
    .PARAMETER destPort
        specift 'any', a single port like '53', or a port-range like '21-23'.
        comma-separated values are NOT supported althought the API documentation says otherwise.
    .PARAMETER destCidr
        specify the destination network by IP address or CIDR notation
        e.g: 10.0.5.0/24
        e.g: 192.168.1.50, 192.168.1.50/32
    .PARAMETER action
        specify 'add' or 'remove'
        Add will add the rule as new topmost entry.
        Remove will find the rule specified by the unique combination of protocol,destport and destCidr or comment.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$ssidID,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$comment,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$policy,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$protocol,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$destPort,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$destCidr,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$action,
        [Parameter()][String]$allowLanAccess=$true
    )

    #$ruleSource = Import-Csv -Path "C:\Users\YS0\OneDrive - Van Oord\Scripts\Meraki\demorules.txt" -Delimiter "`t";
    $ruleSource = Get-MrkNetworkMRL3FirewallRules -networkID $networkID -ssidID $ssidID
    #the non-default rules are in the array above the 2 default
    $rules = $ruleSource[0..$(($ruleSource.Count) -3)]
    
    $ruleset = @()
    #populate the ruleset first with the new rule when the action is 'add'
    if ($action -eq 'add'){
        $ruleEntry = New-Object -TypeName PSObject -Property @{
            comment  = $comment
            policy   = $policy
            protocol = $protocol
            destPort = $destPort
            destCidr = $destCidr
        }

        $ruleset += $ruleEntry
    };
    ForEach ($rule in $rules){

        #if the action is delete and either the current rule comment matches the given comment, or the rule specifications protocol/destPort/destCidr are equal keep the entry in the ruleset. 
        if ($action -eq 'remove' -and (($rule.protocol -ne $protocol -and $rule.destPort -ne $destPort -and $rule.destCidr -ne $destCidr) -or ($rule.comment -ne $comment))){"No longer adding this rule: $comment";continue}

        #add this exising rule to the $ruleset object
        $ruleEntry = New-Object -TypeName PSObject -Property @{
            comment  = $rule.comment
            policy   = $rule.policy
            protocol = $rule.protocol
            destPort = $rule.destPort
            destCidr = $rule.destCidr
        }

        $ruleset += $ruleEntry

    }
    #$ruleset

    #construct the full ruleObject to push into the $body of the RESTapi request
    $ruleObject = New-Object -TypeName PSObject -Property @{
        rules = $ruleset
        allowLanAccess = $allowLanAccess
    }
    $ruleObject

    #construct the uri of the MR device in the current organization
    $uri = "$(Get-MrkOrgEndpoint)/networks/$networkID/ssids/$ssidID/l3FirewallRules"

    try {
        $request = Invoke-RestMethod -Method Put `
        -ContentType 'application/json' `
        -Headers (Get-MrkRestApiHeader) `
        -Uri $uri `
        -Body ($ruleObject | ConvertTo-Json) -Verbose -ErrorAction Stop

        Write-Host "succesfully updated firewall rules" -ForegroundColor Green
    }
    catch
    {
        $_.exception
    }

    Return ($request | ConvertTo-Json)
}