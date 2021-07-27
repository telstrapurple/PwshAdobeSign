[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
Param()

$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Update-UserGroup' {

    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1', '.ps1').Replace('tests', 'functions')

        $validId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires an UserId to be supplied' -Skip:$IsInteractive {
        { Update-UserGroup -GroupId $validId -Confirm:$false } | Should -Throw
    }

    It 'Requires an GroupId to be supplied' -Skip:$IsInteractive {
        { Update-UserGroup -UserId $validId -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to not be $null' {
        { Update-UserGroup -UserId $null -GroupId $validId -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to not be $null' {
        { Update-UserGroup -UserId $validId -GroupId $null -Confirm:$false } | Should -Throw
    }

    It 'Handles a UserId up to 512 characters' {
        Mock Invoke-Method { }
        Update-UserGroup -GroupId $validId -Confirm:$false -UserId 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Handles a GroupId up to 512 characters' {
        Mock Invoke-Method { }
        Update-UserGroup -UserId $validId -Confirm:$false -GroupId 'WvbdOsJLKEBlga438kZK/N8eJ+qPkmrnXpfq8MNdbae45SjyzMFsTQAspOxgF7eMUj6s7DEKIm728gNU+sv7FWXa0C73DOmJiF/GJTD7QvGr7N74z0H6OYe6qr6gwEBj697buszCZIZYMXC+ZIAJ03kuNjGhfU/rn+eQwphLyMWKCYNRcz1JWVnp/XOctqugaqqjj1GGhtjM4dV+EAorrsiUMmIhbK/XtIA9S5fZJbWL6C1+NEu3w6I/MoqYdk4ZeW5enFk9ugXO0RYfEn5yeHQRTEeB9UppeKKlT9MCXNDxcPQdLfTaZlEypmKklrYNB4ah9po/7k+PaYzgXN3tdponXKx/EWwT+DGnUEBDN04vkjDo7giNf7Yfi+gQgbdWNGcB5i88fNKjbnA/i83membnrKnXRmF7T9MnbqLG1OL34P0uTzxeEFdj1ZQ8IB/PnB8iVZ3+5t+zLthyvFv+aXJikmDA7XlDwsCFLtLhVGsLziLVNSV4B/GOdb2ME8c6'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It "Requires Status to be 'Active' or 'Deleted'" {
        Mock Invoke-Method { }
        { Update-UserGroup -UserId $validId -GroupId $validId -Status 'Fox' -Confirm:$false } | Should -Throw
        Update-UserGroup -UserId $validId -GroupId $validId -Status 'Active' -Confirm:$false
        Update-UserGroup -UserId $validId -GroupId $validId -STatus 'Deleted' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 2
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/[^/]+/groups$' }
        Update-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Update-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match "/$validId/" }
        Update-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupId' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].id -eq $validId }
        Update-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Status - Default Active' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].status -eq 'Active' }
        Update-UserGroup -UserId $validId -GroupId $validId -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Status - Active' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].status -eq 'Active' }
        Update-UserGroup -UserId $validId -GroupId $validId -Status 'Active' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Status - Deleted' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].status -eq 'Deleted' }
        Update-UserGroup -UserId $validId -GroupId $validId -Status 'Deleted' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupAdmin - True' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].isGroupAdmin -eq $true }
        Update-UserGroup -UserId $validId -GroupId $validId -IsGroupAdmin $true -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupAdmin - False' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].isGroupAdmin -eq $false }
        Update-UserGroup -UserId $validId -GroupId $validId -IsGroupAdmin $false -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the PrimaryAdmin - True' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].isPrimaryGroup -eq $true }
        Update-UserGroup -UserId $validId -GroupId $validId -IsPrimaryGroup $true -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the PrimaryAdmin - False' {
        Mock Invoke-Method { } -ParameterFilter { $Body.groupInfoList[0].isPrimaryGroup -eq $false }
        Update-UserGroup -UserId $validId -GroupId $validId -IsPrimaryGroup $false -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Invoke-Method { }
        Update-UserGroup -UserId $validId -GroupId $validId -WhatIf
        Should -Invoke Invoke-Method -Exactly 0
    }
}
