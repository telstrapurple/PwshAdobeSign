
function Get-Agreement {
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
        PS /> Get-AdobeSignAgreement -GroupId hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK

        Gets all agreements from a group.
    .EXAMPLE
        PS /> Get-AdobeSignAgreement -ShowHiddenAgreements $true

        Gets all agreements including hidden agreements.
    .EXAMPLE
        PS /> Get-AdobeSignAgreement -Context $context

        Gets a list of all agreements using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(DefaultParameterSetName = 'all')]
    Param (
        # The ID of the agreement.
        [Parameter(Mandatory, ParameterSetName = 'id')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Id,

        # The ID of the group.
        [Parameter(ParameterSetName = 'all')]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupId,

        # Show agreements that have been hidden.
        [Parameter(ParameterSetName = 'all')]
        [Boolean]
        $ShowHiddenAgreements = $false,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    switch ($PSCmdlet.ParameterSetName) {
        'id' {
            $path = "/agreements/$Id"
        }
        default {
            $path = "/agreements?showHiddenAgreements=$showHiddenAgreements"
            if ($PSBoundParameters.ContainsKey('GroupId')) {
                $path += "&groupId=$GroupId"
            }
        }
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    if ($result) {
        if ($result | Get-Member -Name userAgreementList) {
            $result | ForEach-Object userAgreementList
        } else {
            $result
        }
    }
}
