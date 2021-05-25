
function Update-AgreementVisibility {
    <#
    .SYNOPSIS
        Returns a list of agreements or a specified agreement.
    .DESCRIPTION
        Returns a list of agreements or a specified agreement.
    .EXAMPLE
        PS /> Get-AdobeSignAgreement

        Gets a list of all agreements
    .EXAMPLE
        PS /> Get-AdobeSignAgreement -Id hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Gets an agreement using its id.
    .EXAMPLE
        PS /> Get-AdobeSignAgreement -Context $context

        Gets a list of all agreements using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        # The ID of the agreement.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Id,

        [Parameter(Mandatory)]
        [ValidateSet('SHOW', 'HIDE')]
        [String]
        $Visibility,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/agreements/$Id/me/visibility"
    $Body = @{
        visibility = $Visibility
    }

    if ($PSCmdlet.ShouldProcess($Id, "Update visibility: $Visibility")) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $Body -Verbose:$VerbosePreference
        if ($result) {
            if ($result | Get-Member -Name userAgreementList) {
                $result | ForEach-Object userAgreementList
            } else {
                $result
            }
        }
    }
}
