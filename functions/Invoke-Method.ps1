
function Invoke-Method {
    <#
    .SYNOPSIS
        Invokes a AdobeSign Api Method
    .DESCRIPTION
        Invokes a AdobeSign Api Method
    .EXAMPLE
        PS /> Invoke-AdobeSignMethod -Path '/users'

        Makes a GET request to the /users endpoint.
    .EXAMPLE
        PS /> Invoke-AdobeSignMethod -Method 'Delete' -Path '/users/6'

        Makes a DELETE request to the /users/{user_id} endpoint.
    .EXAMPLE
        PS /> Invoke-AdobeSignMethod -Path '/users' -Retry $false

        Makes a GET request to the /users endpoint without automatic retry in case of api rate limiting or transient network issues.
    .EXAMPLE
        PS /> Invoke-AdobeSignMethod -Method 'Update' -Path '/users/6' -Body @{ permissions = 64 }

        Makes a Update request to the /users/{user_id} endpoint to update the permissions level.
    .EXAMPLE
        PS /> Invoke-AdobeSignMethod -Context $context -Path '/users'

        Makes a GET request to the /users endpoint using a connection context.
    .NOTES
        $Body is automatically converted to Json
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Rest Method
        [Parameter()]
        [ValidateSet('Delete', 'Get', 'Post', 'Put')]
        [String]
        $Method = 'Get',

        # Path of the rest request. eg `/Account`
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        # Body of the Rest call
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $Body,

        # Whether to retry when rate limited.
        [Parameter()]
        [Boolean]
        $Retry = $true,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    # Determine the context
    if ($null -eq $Context) {
        if (Test-Path Variable:\Script:Context) {
            $Context = $Script:Context
        } else {
            throw $Script:NotConnectedMessage
        }
    }

    $params = @{
        Method  = $Method
        Verbose = $VerbosePreference
        Headers = @{
            'Accept' = 'application/json'
        }
    }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        # PS Core added native auth token support
        $params.Authentication = 'Bearer'
        $params.Token = $Context.IntegrationKey.Password
    } else {
        # PS Desktop requires manual header creation.
        $params.Headers['Bearer'] = $Context.IntegrationKey.GetNetworkCredential().Password
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        $params.Body = $Body | ConvertTo-Json -Depth 10 -Compress
        $params.ContentType = 'application/json'
        $params.Body | Out-String | Write-Debug
    }

    $uri = $Context.ApiBaseUri + 'api/rest/v6/' + $Path.TrimStart('/')

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $multiplier = 0.5
    while (-not [String]::IsNullOrEmpty($uri)) {
        try {
            $result = Invoke-RestMethod @params -Uri $uri
            $result
            $uri = $null
        } catch {
            $errorRecord = $_
            if ($errorRecord.Exception.GetType().Name -in @('HttpResponseException', 'WebException')) {
                $response = $errorRecord.Exception.Response

                if ($Retry -and $response -and $response.StatusCode -in @(429, 502, 503, 504)) {
                    $response | Select-Object StatusCode, ReasonPhrase | ConvertTo-Json -Compress | Write-Warning

                    $retryAfter = 5
                    if ($errorRecord.Exception -is [System.Net.WebException]) {
                        if ($response.Headers['Retry-After']) {
                            $retryAfter = $response.Headers['Retry-After']
                        }
                    } else {
                        if ($response.Headers.RetryAfter) {
                            $retryAfter = $response.Headers.RetryAfter.Delta.TotalSeconds
                        }
                    }

                    $multiplier *= 2
                    $jitter = Get-Random -Minimum 0.0 -Maximum 1.0
                    $sleep = $retryAfter + $multiplier + $jitter

                    if ($sleep -gt 30) {
                        Write-Warning -Message "Long sleep! $sleep"
                    }
                    $null = Start-Sleep -Seconds $sleep

                } else {
                    $errorMessage = $errorRecord.ToString()
                    Get-PSCallStack | ForEach-Object { $errorMessage += "`n" + $_.Command + ': line ' + $_.ScriptLineNumber }
                    throw $errorMessage
                }
            } else {
                $errorMessage = $errorRecord.ToString()
                Get-PSCallStack | ForEach-Object { $errorMessage += "`n" + $_.Command + ': line ' + $_.ScriptLineNumber }
                throw $errorMessage
            }
        }
    }
}
