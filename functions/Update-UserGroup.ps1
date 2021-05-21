
function Update-UserGroup {
    <#
    .SYNOPSIS
        Updates the group assignments for a user
    .DESCRIPTION
        Updates the group assignments for a user
    .EXAMPLE
        PS /> $params = @{
            UserId  = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            GroupId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            Status  = 'Active'
        }
        PS /> Update-AdobeSignUserGroup @params

        Adds a user to a group.
    .EXAMPLE
        PS /> $params = @{
            UserId  = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            GroupId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            Status  = 'Remove'
        }
        PS /> Update-AdobeSignUserGroup @params

        Removes a user from a group.
    .EXAMPLE
        PS /> $params = @{
            UserId     = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            GroupId    = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            Status     = 'Active'
            GroupAdmin = $true
        }
        PS /> Update-AdobeSignUserGroup @params

        Makes the user a group admin.
    .EXAMPLE
        PS /> $params = @{
            UserId       = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            GroupId      = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            Status       = 'Active'
            PrimaryGroup = $true
        }
        PS /> Update-AdobeSignUserGroup @params

        Makes the group primary for a user.
    .EXAMPLE
        PS /> $params = @{
            UserId  = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            GroupId = 'hXy4R2NaYnvTaftrEhaD4ZAJrxh3YM8kuf8CupEouFoK'
            Status  = 'Active'
            Context = $context
        }
        PS /> Update-AdobeSignUserGroup @params

        Adds a user to a group using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # The ID of the group.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $GroupId,

        [Parameter()]
        [ValidateSet('ACTIVE', 'DELETED')]
        [String]
        $Status = 'ACTIVE',

        # Make the user a group admin
        [Parameter()]
        [Boolean]
        $GroupAdmin,

        # Set as the primary group for the user
        [Parameter()]
        [Boolean]
        $PrimaryGroup,

        # Adobe Sign Connection Context from `Get-AdobeSignConnection`
        [Parameter()]
        [PSTypeName('AdobeSignContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$UserId/groups"
    $body = @{
        groupInfoList = @(
            @{
                id     = $GroupId
                status = $Status
            }
        )
    }

    if ($PSBoundParameters.ContainsKey('GroupAdmin')) {
        $body.groupInfoList[0].isGroupAdmin = $GroupAdmin
    }

    if ($PSBoundParameters.ContainsKey('PrimaryGroup')) {
        $body.groupInfoList[0].isPrimaryGroup = $PrimaryGroup
    }

    if ($PSCmdlet.ShouldProcess($UserId, 'Set Group Membership')){
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }
}
