
function Get-User {
    <#
    .SYNOPSIS
        Returns a list of users or a specified user.
    .DESCRIPTION
        Returns a list of users or a specified user.
    .EXAMPLE
        PS /> Get-AdobeSignUser

        Gets a list of all users
    .EXAMPLE
        PS /> Get-AdobeSignUser -UserId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Gets a user using their id.
    .EXAMPLE
        PS /> Get-AdobeSignUser -Context $context

        Gets a list of all users using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the user.
        [Parameter()]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $Id,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSBoundParameters.ContainsKey('Id')) {
        $path = "/users/$Id"
    } else {
        $path = '/users'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    if ($result) {
        if ($result | Get-Member -Name userInfoList) {
            $result | ForEach-Object userInfoList
        } else {
            $result
        }
    }
}
