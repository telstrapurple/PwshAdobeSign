[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
Param()

$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Show-Agreement' {

    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1', '.ps1').Replace('tests', 'functions')

        $validId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'

        function Update-AgreementVisibility ($Id, $Visibility) { }
    }

    It 'Requires an Id to be supplied' -Skip:$IsInteractive {
        { Show-Agreement } | Should -Throw
    }

    It 'Requires Id to not be $null' {
        { Show-Agreement -Id $null } | Should -Throw
    }

    It 'Handles an Id up to 512 characters' {
        Mock Update-AgreementVisibility { }
        Show-Agreement -Id 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Update-AgreementVisibility -Exactly 1
    }

    It 'Passes on the Id' {
        Mock Update-AgreementVisibility { } -ParameterFilter { $Id -eq $validId }
        Show-Agreement -Id $validId
        Should -Invoke Update-AgreementVisibility -Exactly 1
    }

    It 'Passes on the correct Visibility' {
        Mock Update-AgreementVisibility { } -ParameterFilter { $Visibility -eq 'SHOW' }
        Show-Agreement -Id $validId
        Should -Invoke Update-AgreementVisibility -Exactly 1
    }
}
