
function Get-BaseUri {
    <#
    .SYNOPSIS
        Returns the Adobe Sign base uris for a given connection
    .DESCRIPTION
        Returns the Adobe Sign base uris for a given connection
    .EXAMPLE
        PS /> $integrationKey = Read-Host -Prompt 'Adobe Sign Integration Key' -AsSecureString
        PS /> $baseUris = Get-AdobeSignBaseUri -IntegrationKey $integrationKey

        Sets $baseUris to a baseUri object using an integration key read from the command line.
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

    $params = @{
        Uri     = 'https://api.adobesign.com/api/rest/v6/baseUris/'
        Headers = @{
            Accept = 'application/json'
        }
    }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        # PS Core added native auth token support
        $params.Authentication = 'Bearer'
        $params.Token = $IntegrationKey
    } else {
        # PS Desktop requires manual header creation.
        $params.Headers['Bearer'] = [PSCredential]::new('IntegrationKey', $IntegrationKey).GetNetworkCredential().Password
    }

    $result = Invoke-RestMethod @params
    $result
}
