
function Remove-UserGroup {
    <#
    .SYNOPSIS
        Removes a user from a group.
    .DESCRIPTION
        Removes a user from a group.
    .EXAMPLE
        PS /> Remove-AdobeSignUserGroup -UserId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK -GroupId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Removes a user from a group.
    .EXAMPLE
        PS /> Remove-AdobeSignUserGroup -Context $context -UserId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK -GroupId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Removes a user from a group using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # The ID of the group.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $GroupId,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSCmdlet.ShouldProcess($UserId, 'Add Group Membership')){
        $result = Set-UserGroup @PSBoundParameters -Status 'DELETED' -Verbose:$VerbosePreference -Confirm:$false
        $result
    }
}
