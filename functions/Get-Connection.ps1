
function Get-Connection {
    <#
    .SYNOPSIS
        Returns a Adobe Sign connection context
    .DESCRIPTION
        Returns an object describing a connection to Adobe Sign
    .EXAMPLE
        PS /> $integrationKey = Read-Host -Prompt 'Adobe Sign Integration Key' -AsSecureString
        PS /> $context = Get-AdobeSignConnection -IntegrationKey $integrationKey

        Sets $context to a connection context using an iuntegration key read from the command line.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Adobe Sign API Integration Key managed from the "Access Tokens" section under "Personal Preferrences"
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $IntegrationKey

        # RefreshToken
    )

    $baseUris = Get-BaseUri @PSBoundParameters

    $context = [PSCustomObject]@{
        IntegrationKey = [PSCredential]::new('IntegrationKey', $IntegrationKey)
        ApiBaseUri     = $baseUris.apiAccessPoint
    }

    $context | Add-Member -TypeName 'AdobeSignContext'
    $context
}
