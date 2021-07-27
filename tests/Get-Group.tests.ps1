$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Get-Group' {

    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1', '.ps1').Replace('tests', 'functions')

        $validId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Allows no parameters to be passed' -Skip:$IsInteractive {
        Mock Invoke-Method { }
        Get-Group
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Allows Id to be passed' -Skip:$IsInteractive {
        Mock Invoke-Method { }
        Get-Group -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Requires Id to not be $null' {
        { Get-Group -Id $null } | Should -Throw
    }

    It 'Handles a Id up to 512 characters' {
        Mock Invoke-Method { }
        Get-Group -Id 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Hits the correct endpoint - all' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups$' }
        Get-Group
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Hits the correct endpoint - Id' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups/[^/]+$' }
        Get-Group -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method - all' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-Group
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method - Id' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-Group -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Id' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match "/$validId$" }
        Get-Group -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
    }
}
