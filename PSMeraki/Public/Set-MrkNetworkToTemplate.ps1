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
    [CmdletBinding()]
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