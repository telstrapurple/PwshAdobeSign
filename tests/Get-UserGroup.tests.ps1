$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Get-UserGroup' {

    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1', '.ps1').Replace('tests', 'functions')

        $validId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires an Id to be supplied' -Skip:$IsInteractive {
        { Get-UserGroup } | Should -Throw
    }

    It 'Requires UserId to not be $null' {
        { Get-UserGroup -Id $null } | Should -Throw
    }

    It 'Handles a UserId up to 512 characters' {
        Mock Invoke-Method { }
        Get-UserGroup -Id 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/[^/]+/groups$' }
        Get-UserGroup -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-UserGroup -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Id' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match "/$validId/groups$" }
        Get-UserGroup -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Expands the wrapper property' {
        Mock Invoke-Method { [PSCustomObject]@{ groupInfoList = @(1, 2, 3) } }
        $result = Get-UserGroup -Id $validId
        Should -Invoke Invoke-Method -Exactly 1
        $result | Get-Member -Name 'groupInfoList' | Should -BeNullOrEmpty
        $result | Should -Be @(1, 2, 3)
    }
}
