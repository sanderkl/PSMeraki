function Update-MrkNetworkMXL3FwRule {
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
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$networkId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$comment,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("allow", "deny")]
        [String]$policy,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("any", "tcp","udp","icmp")]
        [String]$protocol,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$srcPort,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$srcCidr,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$destPort,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$destCidr,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("add", "remove")]
        [String]$action,

        [Parameter()]
        [switch]$reset
    )

    #$ruleSource = Import-Csv -Path "C:\Users\YS0\OneDrive - Van Oord\Scripts\Meraki\demorules.txt" -Delimiter "`t";
    $ruleset = @()
    if (-not $reset){
        $ruleSource = Get-MrkNetworkMXL3FwRule -networkID $networkId
        #the non-default rules are in the array above the default
        $ruleset = $ruleSource[0..$(($ruleSource.Count) -2)]
    }
    
    #populate the to-be ruleset first with the existing rules (will be none in case of reset)
    $applyRules = @()
    ForEach ($rule in $ruleset){

        #if the action is delete and either the current rule comment matches the given comment, or the rule specifications protocol/destPort/destCidr are equal keep the entry in the ruleset. 
        if ($action -eq 'remove' -and `
          (($rule.protocol -eq $protocol -and `
            $rule.destPort -eq $destPort -and `
            $rule.destCidr -eq $destCidr) -or `
            ($rule.comment -eq $comment))){
                "No longer adding this rule: $comment";
                continue
            }

        if ($action -eq 'add' -and `
            (($rule.protocol -eq $protocol -and `
              $rule.srcPort -eq $srcPort -and `
              $rule.srcCidr -eq $srcCidr -and `
              $rule.destPort -eq $destPort -and `
              $rule.destCidr -eq $destCidr) -or `
              ($rule.comment -eq $comment))){
                  "Not adding this rule as it is already present: $comment";
                  $rulePresent = $true
              }
          
        #add this exising rule to the $ruleset object
        $ruleEntry = New-Object -TypeName PSObject -Property @{
            comment  = $rule.comment
            policy   = $rule.policy
            protocol = $rule.protocol
            srcPort  = $rule.srcPort
            srcCidr  = $rule.srcCidr
            destPort = $rule.destPort
            destCidr = $rule.destCidr
        }

        $applyRules += $ruleEntry

    }

    #append the new ruleobject to the applyRules
    if ($action -eq 'add' -and $true -ne $rulePresent){
        $ruleEntry = New-Object -TypeName PSObject -Property @{
            comment  = $comment
            policy   = $policy
            protocol = $protocol
            srcPort  = $srcPort
            srcCidr  = $srcCidr
            destPort = $destPort
            destCidr = $destCidr
        }

        $applyRules += $ruleEntry
    };

    #construct the full ruleObject to push into the $body of the RESTapi request
    $ruleObject = New-Object -TypeName PSObject -Property @{
        rules = $applyRules
    }

    if($true -ne $rulePresent){

        $request = Invoke-MrkRestMethod -Method PUT -ResourceID ('/networks/' + $networkID + '/l3FirewallRules') -body $ruleObject
        return $request

        # #construct the uri of the MR device in the current organization
        # $uri = "$(Get-MrkOrgEndpoint)/networks/$networkID/l3FirewallRules"
        # try {
        #     $request = Invoke-RestMethod -Method Put `
        #     -ContentType 'application/json' `
        #     -Headers (Get-MrkRestApiHeader) `
        #     -Uri $uri `
        #     -Body ($ruleObject | ConvertTo-Json) -Verbose -ErrorAction Stop

        #     Write-Host "succesfully updated firewall rules" -ForegroundColor Green
        # }
        # catch
        # {
        #     $_.exception
        # }

        Return ($request | ConvertTo-Json)
    }
}
