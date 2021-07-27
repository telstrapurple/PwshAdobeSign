$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Remove-UserGroup' {

    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1', '.ps1').Replace('tests', 'functions')

        $validId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'

        function Update-UserGroup ($UserId, $GroupId, $Status) { }
    }

    It 'Requires an UserId to be supplied' -Skip:$IsInteractive {
        { Remove-UserGroup -GroupId $validId -Confirm:$false } | Should -Throw
    }

    It 'Requires an GroupId to be supplied' -Skip:$IsInteractive {
        { Remove-UserGroup -UserId $validId -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to not be $null' {
        { Remove-UserGroup -UserId $null -GroupId $validId -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to not be $null' {
        { Remove-UserGroup -UserId $validId -GroupId $null -Confirm:$false } | Should -Throw
    }

    It 'Handles a UserId up to 512 characters' {
        Mock Update-UserGroup { }
        Remove-UserGroup -GroupId $validId -Confirm:$false -UserId 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Update-UserGroup -Exactly 1
    }

    It 'Handles a GroupId up to 512 characters' {
        Mock Update-UserGroup { }
        Remove-UserGroup -UserId $validId -Confirm:$false -GroupId 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Update-UserGroup -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Update-UserGroup { } -ParameterFilter { $UserId -eq $validId }
        Remove-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Update-UserGroup -Exactly 1
    }

    It 'Passes on the GroupId' {
        Mock Update-UserGroup { } -ParameterFilter { $GroupId -eq $validId }
        Remove-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Update-UserGroup -Exactly 1
    }

    It 'Sets on the Status' {
        Mock Update-UserGroup { } -ParameterFilter { $Status -eq 'Deleted' }
        Remove-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Update-UserGroup -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Update-UserGroup { }
        Remove-UserGroup -UserId $validId -GroupId $validId -WhatIf
        Should -Invoke Update-UserGroup -Exactly 0
    }
}
