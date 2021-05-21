
function Connect- {
    <#
    .SYNOPSIS
        Connects to a Adobe Sign instance.
    .DESCRIPTION
        Connects to a Adobe Sign instance. Overriding any existing connection established previously with this function.
    .EXAMPLE
        PS /> $integrationKey = Read-Host -Prompt 'Adobe Sign Integration Key' -AsSecureString
        PS /> Connect-AdobeSign -IntegrationKey $integrationKey

        Connects to Adobe Sign using an integration key read from the command line.
    #>
    [OutputType([Boolean])]
    [CmdletBinding()]
    Param (
        # Adobe Sign API Integration Key managed from the "Access Tokens" section under "Personal Preferrences"
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $IntegrationKey

        # RefreshToken
    )

    $Script:Context = Get-Connection @PSBoundParameters

    $true
}
