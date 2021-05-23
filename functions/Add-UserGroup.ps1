
function Add-UserGroup {
    <#
    .SYNOPSIS
        Adds a user to a group.
    .DESCRIPTION
        Adds a user to a group.
    .EXAMPLE
        PS /> Add-AdobeSignUserGroup -UserId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK -GroupId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Adds a user to a group.
    .EXAMPLE
        PS /> Add-AdobeSignUserGroup -Context $context -UserId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK -GroupId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Adds a user to a group using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserId,

        # The ID of the group.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupId,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSCmdlet.ShouldProcess($UserId, 'Add Group Membership')){
        $result = Set-UserGroup @PSBoundParameters -Status 'ACTIVE' -Verbose:$VerbosePreference -Confirm:$false
        $result
    }
}
