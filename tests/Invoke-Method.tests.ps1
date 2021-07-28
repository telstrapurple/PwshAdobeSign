[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidOverwritingBuiltInCmdlets', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
Param()

Import-Module "$PSScriptRoot/../PwshAdobeSign.psm1" -Force

Describe 'Invoke-Method' -Tags 'internet' {

    InModuleScope PwshAdobeSign {

        BeforeAll {
            $IRM = Get-Command -Name 'Invoke-RestMethod' -Module 'Microsoft.PowerShell.Utility'

            $connectionContext = @{
                ApiBaseUri     = 'https://documents.adobe.test/api'
                IntegrationKey = [PSCredential]::New("IntegrationKey", ('integration-key' | ConvertTo-SecureString -AsPlainText -Force))
            }
            $connectionContext | Add-Member -TypeName 'AdobeSignContext'

            function Invoke-RestMethod { [CMDletBinding()] Param ($Method = 'Get', $Uri, $Headers, $Body, $Token, $ContentType, $OutFile, $Authentication) }
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod { }
        }

        It 'Uses the baseUrl' {
            Invoke-Method -Context $connectionContext -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match 'https://documents.adobe.test/api' } -Scope It
        }

        It 'Uses the path' {
            Invoke-Method -Context $connectionContext -Path '/Thing'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match '/Thing' } -Scope It
        }

        It 'Accepts JSON' {
            Invoke-Method -Context $connectionContext -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                $Headers.ContainsKey('Accept') -and $Headers.Accept -match 'application\/json'
            } -Scope It
        }

        It 'Cascades Verbose' {
            Invoke-Method -Context $connectionContext -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { -not $Verbose } -Scope It

            Invoke-Method -Context $connectionContext -Path '/' -Verbose
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Verbose } -Scope It

            Invoke-Method -Context $connectionContext -Path '/' -Verbose:$false
            Assert-MockCalled Invoke-RestMethod -Exactly 2 -ParameterFilter { -not $Verbose } -Scope It
        }

        It 'Default Method: Get' {
            Invoke-Method -Context $connectionContext -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' } -Scope It
        }

        It 'Explicit Method: Get' {
            Invoke-Method -Context $connectionContext -Method 'Get' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' } -Scope It
        }

        It 'Explicit Method: Post' {
            Invoke-Method -Context $connectionContext -Method 'Post' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' } -Scope It
        }

        It 'Explicit Method: Put' {
            Invoke-Method -Context $connectionContext -Method 'Put' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' } -Scope It
        }

        It 'Explicit Method: Delete' {
            Invoke-Method -Context $connectionContext -Method 'Delete' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' } -Scope It
        }

        It 'Throws with no connection' {
            { Invoke-Method -Path '/' } | Should -Throw
        }

        It 'Throws with no invalid connection type' {
            $block = {
                $connectionContext = [PSCustomObject]@{
                    Organization = 'company'
                    BaseUrl      = 'https://documents.adobe.test/api'
                    Credential   = $null
                }
                Invoke-Method -Path '/' -Context $connectionContext
            }
            $block | Should -Throw
        }

        It 'Converts Body to JSON by default' {
            Invoke-Method -Context $connectionContext -Method 'Post' -Path '/' -Body ([PSCustomObject]@{ A = 1; B = 2; C = 3 })
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Body -eq '{"A":1,"B":2,"C":3}' } -Scope It
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $ContentType -eq 'application/json' } -Scope It
        }

        It 'Throws on a 404' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod { & $IRM 'httpstat.us/404' }
            { Invoke-Method -Context $connectionContext -Path '/' } | Should -Throw
        }

        It 'Passes on 404 error message' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod { & $IRM 'httpstat.us/404' }
            try { Invoke-Method -Context $connectionContext -Path '/' } catch { $E = $_ }
            $E | Should -Match '\(?404\)? \(?Not Found\)?'
        }

        It 'Passes on 400 error message' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod { & $IRM 'httpstat.us/400' }
            try { Invoke-Method -Context $connectionContext -Path '/' } catch { $E = $_ }
            $E | Should -Match '\(?400\)? \(?Bad Request\)?'
        }

        It 'Passes on 500 error message' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod { & $IRM 'httpstat.us/500' }
            try { Invoke-Method -Context $connectionContext -Path '/' } catch { $E = $_ }
            $E | Should -Match '\(?500\)? \(?Internal Server Error\)?'
        }

        It 'Passes on Calling function' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod { & $IRM 'httpstat.us/500' }
            try { Invoke-Method -Context $connectionContext -Path '/' } catch { $E = $_ }
            $E | Should -Match '<ScriptBlock>: line 1\d\d'
        }

        It 'Does not rety if requested not to' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod {
                $Script:attempts += 1
                if ($Script:attempts -lt 3) {
                    & $IRM 'httpstat.us/429'
                }
            }
            $Script:attempts = 0
            { Invoke-Method -Context $connectionContext -Path '/' -Retry $false } | Should -Throw
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -Scope It
        }

        It 'Retries by default' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod {
                $Script:attempts += 1
                if ($Script:attempts -lt 3) {
                    & $IRM 'httpstat.us/429'
                }
            }
            $Script:attempts = 0
            Invoke-Method -Context $connectionContext -Path '/' 3>$null
            Assert-MockCalled Invoke-RestMethod -Exactly 3 -Scope It
        }

        It 'Retries explicitly' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod {
                $Script:attempts += 1
                if ($Script:attempts -lt 3) {
                    & $IRM 'httpstat.us/429'
                }
            }
            $Script:attempts = 0
            Invoke-Method -Context $connectionContext -Path '/' -Retry $true 3>$null
            Assert-MockCalled Invoke-RestMethod -Exactly 3 -Scope It
        }

        It 'Uses the stored context' {
            Mock -ModuleName PwshAdobeSign Invoke-RestMethod { }
            $Script:Context = $connectionContext
            Invoke-Method -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -Scope It
        }
    }
}
