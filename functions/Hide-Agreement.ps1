
function Hide-Agreement {
    <#
    .SYNOPSIS
        Hides a specified agreement.
    .DESCRIPTION
        Hides a specified agreement.
    .EXAMPLE
        PS /> Hide-AdobeSignAgreement -Id hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Hides an agreement using its id.
    .EXAMPLE
        PS /> Hide-AdobeSignAgreement -Context $context -Id hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Hides an agreements using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the agreement.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $Id,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    $result = Update-AgreementVisibility @PSBoundParameters -Visibility 'HIDE' -Verbose:$VerbosePreference -Confirm:$false
    $result
}
