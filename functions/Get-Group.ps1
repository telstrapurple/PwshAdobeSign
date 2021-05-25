
function Get-Group {
    <#
    .SYNOPSIS
        Returns a list of groups or a specified group.
    .DESCRIPTION
        Returns a list of groups or a specified group.
    .EXAMPLE
        PS /> Get-AdobeSigngroup

        Gets a list of all groups
    .EXAMPLE
        PS /> Get-AdobeSigngroup -Id hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Gets a group using its id.
    .EXAMPLE
        PS /> Get-AdobeSigngroup -Context $context

        Gets a list of all groups using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the group.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Id,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSBoundParameters.ContainsKey('Id')) {
        $path = "/groups/$Id"
    } else {
        $path = '/groups'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    if ($result) {
        if ($result | Get-Member -Name groupInfoList) {
            $result | ForEach-Object groupInfoList
        } else {
            $result
        }
    }
}
