function Get-MrkNetworkMXL7AppCategory {
    <#
    .SYNOPSIS
    Retrieve the available L7 filtering/protection Application categories.
    .DESCRIPTION
    Retrieve the available L7 filtering/protection Application categories. These categories are used to setup L7 firewall or traffic shaping rules
    .EXAMPLE
    Get-MrkMxL7AppCategory -networkId L_112233445566778899
    .EXAMPLE
    $l7ac = Get-MrkMxL7AppCategory -networkId L_112233445566778899
    $l7ac.applicationCategories
    .PARAMETER networkId
    parameter to specify a specific networkId.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][String]$networkId
    )


    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/l7FirewallRules/applicationCategories') ;

    $colAppCat = @();
    $request.applicationCategories | ForEach-Object {
        
        $catId = ($_.id -split '/')[-1];
        $catName=$_.name;
        $catApps = $_.applications;
        $catApps | ForEach-Object {
            $tmp = New-Object -TypeName PSCustomObject;
            $catAppId = ($_.id -split '/')[-1];
            $catAppName = $_.name;
    
            $tmp | Add-Member -MemberType NoteProperty -Name 'CategoryId' -Value $catId
            $tmp | Add-Member -MemberType NoteProperty -Name 'CategoryName' -Value $catName
            $tmp | Add-Member -MemberType NoteProperty -Name 'ApplicationId' -Value $catAppId
            $tmp | Add-Member -MemberType NoteProperty -Name 'ApplicationName' -Value $catAppName
    
            $colAppCat += $tmp
        }
    }
    
    return $colAppCat
}

