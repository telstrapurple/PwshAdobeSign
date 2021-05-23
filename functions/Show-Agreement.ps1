
function Show-Agreement {
    <#
    .SYNOPSIS
        Shows a specified agreement.
    .DESCRIPTION
        Shows a specified agreement.
    .EXAMPLE
        PS /> Show-AdobeSignAgreement -Id hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Shows an agreement using its id.
    .EXAMPLE
        PS /> Show-AdobeSignAgreement -Context $context -Id hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Shows an agreements using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the agreement.
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

    $result = Update-AgreementVisibility @PSBoundParameters -Visibility 'SHOW' -Verbose:$VerbosePreference -Confirm:$false
    $result
}
