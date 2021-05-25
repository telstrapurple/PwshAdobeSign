
function Get-UserGroup {
    <#
    .SYNOPSIS
        Returns a list of groups for a specified user.
    .DESCRIPTION
        Returns a list of groups for a specified user.
    .EXAMPLE
        PS /> Get-AdobeSignUserGroup -UserId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Gets the groups for a user.
    .EXAMPLE
        PS /> Get-AdobeSignUserGroup -Context $context -UserId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Gets the groups for a user using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Id,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$Id/groups"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    if ($result) {
        if ($result | Get-Member -Name groupInfoList) {
            $result | ForEach-Object groupInfoList
        } else {
            $result
        }
    }
}
