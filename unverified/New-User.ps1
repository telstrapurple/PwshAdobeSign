
function New-User {
    <#
    .SYNOPSIS
        Creates a new user in the Adobe Sign system
    .DESCRIPTION
        Creates a new user in the Adobe Sign system
    .EXAMPLE
        PS /> New-AdobeSignUser -Email 'first.last@company.net'

        Creates a new user in the Adobe Sign system with minimal properties.
    .EXAMPLE
        PS /> Get-AdobeSignUser -Email 'first.last@company.net' -FirstName 'First' -LastName 'Last' -PrimaryGroupId 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'

        Gets a user using their id.
    .EXAMPLE
        PS /> New-AdobeSignUser -Email 'first.last@company.net' -Context $context

        Creates a new user in the Adobe Sign system using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param (
        # The email address of the user,
        [Parameter(Mandatory)]
        [String]
        $Email,

        # True if the user is account admin.
        [Parameter()]
        [Boolean]
        $IsAccountAdmin = $false,

        # The account id of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $AccountId,

        # The name of company of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Company,

        # The first name of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $FirstName,

        # The initials of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Initials,

        # The last name of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $LastName,

        # The UI locale of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Locale,

        # The phone number of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Phone,

        # Primary group in which the new user should be added. Default is the default group for the account the user is being added to.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $PrimaryGroupId,

        # The job title of the user
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Title,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = '/users'
    $body = @{
        DetailedUserInfo = @{
            email          = $Email
            isAccountAdmin = $IsAccountAdmin
        }
    }

    if ($PSBoundParameters.ContainsKey('AccountId')) {
        $body.DetailedUserInfo.accountId = $AccountId
    }
    if ($PSBoundParameters.ContainsKey('Company')) {
        $body.DetailedUserInfo.company = $Company
    }
    if ($PSBoundParameters.ContainsKey('FirstName')) {
        $body.DetailedUserInfo.firstName = $FirstName
    }
    if ($PSBoundParameters.ContainsKey('Initials')) {
        $body.DetailedUserInfo.initials = $Initials
    }
    if ($PSBoundParameters.ContainsKey('LastName')) {
        $body.DetailedUserInfo.lastName = $LastName
    }
    if ($PSBoundParameters.ContainsKey('Locale')) {
        $body.DetailedUserInfo.locale = $Locale
    }
    if ($PSBoundParameters.ContainsKey('Phone')) {
        $body.DetailedUserInfo.phone = $Phone
    }
    if ($PSBoundParameters.ContainsKey('PrimaryGroupId')) {
        $body.DetailedUserInfo.primaryGroupId = $PrimaryGroupId
    }
    if ($PSBoundParameters.ContainsKey('Title')) {
        $body.DetailedUserInfo.title = $Title
    }

    if ($PSCmdlet.ShouldProcess($Email, 'Create User')) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference

        if ($result) {
            if ($result | Get-Member -Name UserCreationResponse) {
                $result | ForEach-Object UserCreationResponse
            } else {
                $result
            }
        }
    }
}
