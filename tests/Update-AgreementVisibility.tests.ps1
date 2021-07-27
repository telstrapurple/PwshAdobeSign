$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Update-AgreementVisibility' {

    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1', '.ps1').Replace('tests', 'functions')

        $validId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires an Id to be supplied' -Skip:$IsInteractive {
        { Update-AgreementVisibility -Visibility 'Hide' } | Should -Throw
    }

    It 'Requires a Visibility to be supplied' -Skip:$IsInteractive {
        { Update-AgreementVisibility -Id $validId } | Should -Throw
    }

    It 'Requires Id to not be $null' {
        { Update-AgreementVisibility -Id $null -Visibility 'Hide' } | Should -Throw
    }

    It 'Requires Visibility to not be $null' {
        { Update-AgreementVisibility -Id $validId -Visibility $null } | Should -Throw
    }

    It "Requires Visibility to be 'Hide' or 'Show'" {
        Mock Invoke-Method { }
        { Update-AgreementVisibility -Id $validId -Visibility 'Fox' } | Should -Throw
        Update-AgreementVisibility -Id $validId -Visibility 'Hide'
        Update-AgreementVisibility -Id $validId -Visibility 'Show'
        Should -Invoke Invoke-Method -Exactly 2
    }

    It 'Handles a Id up to 512 characters' {
        Mock Invoke-Method { }
        Update-AgreementVisibility -Visibility 'Hide' -Id 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/agreements/[^/]+/me/visibility$' }
        Update-AgreementVisibility -Id $validId -Visibility 'Hide'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Update-AgreementVisibility -Id $validId -Visibility 'Hide'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Id' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match "/$validId/" }
        Update-AgreementVisibility -Id $validId -Visibility 'Hide'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Visibility' {
        Mock Invoke-Method { } -ParameterFilter { $Body.visibility -eq 'Hide' }
        Update-AgreementVisibility -Id $validId -Visibility 'Hide'
        Should -Invoke Invoke-Method -Exactly 1
    }
}
