Get-GPO -All | ForEach-Object {
    # Test if Authenticated Users group have at least read permission on the GPO
    if ('S-1-5-11' -notin ($_ | Get-GPPermission -All).Trustee.Sid.Value) {
        $_
    }
} | Select DisplayName

Get-GPO -All | ForEach-Object {
    if ('S-1-5-11' -notin ($_ | Get-GPPermission -All).Trustee.Sid.Value) {
        $_ | Set-GPPermission -PermissionLevel GpoRead -TargetName 'Authenticated Users' -TargetType Group -Verbose
    }
}

Get-GPO -All | ForEach-Object {
    [PsCustomObject]@{
        DisplayName = $_.DisplayName
        Permission = ($_ | Get-GPPermission -TargetName 'Authenticated Users' -TargetType Group).Permission
    }
} | Out-GridView -Title 'Authenticated Users permissions'

gpupdate /force