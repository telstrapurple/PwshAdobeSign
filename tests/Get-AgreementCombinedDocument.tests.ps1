$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Get-AgreementCombinedDocument' {

    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1', '.ps1').Replace('tests', 'functions')

        $validId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
        $validPath = 'agreement.pdf'

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires an Id to be supplied' -Skip:$IsInteractive {
        { Get-AgreementCombinedDocument -OutFile $validPath } | Should -Throw
    }

    It 'Requires an Outfile to be supplied' -Skip:$IsInteractive {
        { Get-AgreementCombinedDocument -Id $validId } | Should -Throw
    }

    It 'Requires Id to not be $null' {
        { Get-AgreementCombinedDocument -Id $null -OutFile $validPath } | Should -Throw
    }

    It 'Requires OutFile to not be $null' {
        { Get-AgreementCombinedDocument -Id $validId -OutFile $null } | Should -Throw
    }

    It 'Handles a Id up to 512 characters' {
        Mock Invoke-Method { }
        Get-AgreementCombinedDocument -OutFile $validPath -Id 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/agreements/[^/]+/combinedDocument\?' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Id' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match "/$validId/" }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the AttachAuditReport - default false' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '[?&]attachAuditReport=False(&|$)' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the AttachAuditReport - false' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '[?&]attachAuditReport=False(&|$)' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath -AttachAuditReport $false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the AttachAuditReport - true' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '[?&]attachAuditReport=True(&|$)' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath -AttachAuditReport $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the AttachSupportingDocuments - default true' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '[?&]AttachSupportingDocuments=True(&|$)' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the AttachSupportingDocuments - false' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '[?&]AttachSupportingDocuments=False(&|$)' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath -AttachSupportingDocuments $false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the AttachSupportingDocuments - true' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '[?&]AttachSupportingDocuments=True(&|$)' }
        Get-AgreementCombinedDocument -Id $validId -OutFile $validPath -AttachSupportingDocuments $true
        Should -Invoke Invoke-Method -Exactly 1
    }
}
