
function Get-AgreementCombinedDocument {
    <#
    .SYNOPSIS
        Downloads an agreement's combined document
    .DESCRIPTION
        Downloads an agreement's combined document
    .EXAMPLE
        PS /> $params = @{
            Id      = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            OutFile = 'agreement.pdf'
        }
        PS /> Update-AdobeSignAgreementCombinedDocument @params

        Downloads an agreement's combined document.
    .EXAMPLE
        PS /> $params = @{
            Id                = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            OutFile           = 'agreement.pdf'
            AttachAuditReport = $true
        }
        PS /> Update-AdobeSignAgreementCombinedDocument @params

        Downloads an agreement's combined document with attached audit report.
    .EXAMPLE
        PS /> $params = @{
            Id                        = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            OutFile                   = 'agreement.pdf'
            AttachSupportingDocuments = $false
        }
        PS /> Update-AdobeSignAgreementCombinedDocument @params

        Downloads an agreement's combined document without attached supporting documents.
    .EXAMPLE
        PS /> $params = @{
            Id      = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            OutFile = 'agreement.pdf'
            Context = $context
        }
        PS /> Update-AdobeSignAgreementCombinedDocument @params

        Downloads an agreement's combined document using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the agreement.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $Id,

        # File to save response to
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $OutFile,

        # If the autdit report should be included
        [Parameter()]
        [Boolean]
        $AttachAuditReport = $false,

        # If all supporting documents should be included
        [Parameter()]
        [Boolean]
        $AttachSupportingDocuments = $true,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/agreements/$Id/combinedDocument?attachAuditReport=$AttachAuditReport&attachSupportingDocuments=$AttachSupportingDocuments"

    $result = Invoke-Method -Context $Context -Path $path -OutFile $OutFile -Verbose:$VerbosePreference
    $result
}
