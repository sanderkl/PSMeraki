Function Get-MrkNetworkTrafficAnalysis {
    <#
    .SYNOPSIS
    Update network traffic analysis settings for a network.
    .DESCRIPTION
    Update network traffic analysis settings for a network by adding / removing settings like host, port or IPRange to analyse.
    .EXAMPLE
    this will set the 
    Update-MrkNetworkTrafficAnalysis -networkId N_1234567890123456 -
    .PARAMETER networkId
    the networkId of the network. Get the id using Get-MrkNetwork
    .PARAMETER mode
    The traffic analysis mode for the network. Can be one of 'disabled' (do not collect traffic types), 'basic' (collect generic traffic categories), or 'detailed' (collect destination hostnames).
    .PARAMETER name
    The name of the custom pie chart item.
    .PARAMETER type
    The signature type for the custom pie chart item. Can be one of 'host', 'port' or 'ipRange'.
    .PARAMETER value
    The value of the custom pie chart item. Valid syntax depends on the signature type of the chart item (see sample request/response for more details).
    #>
    
    #GET/networks/{networkId}/trafficAnalysisSettings
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][String]$networkId
    )

    $request = Invoke-MrkRestMethod -Method GET -ResourceID ('/networks/' + $networkId + '/trafficAnalysisSettings')
    return $request

}