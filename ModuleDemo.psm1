if (-not (Get-Module -Name DataONTAP)) {
    Import-Module-Name DataONTAP
}

. $PSScriptRoot\New-NtapDataVolume.ps1

filter Skip-RootVol {
    if (-not $_.VolumeStateAttributes.IsVserverRoot -and -not $_.VolumeStateAttributes.IsNodeRoot) {
        return $_
    }
}

Export-ModuleMember -Function Skip-RootVol, New-NtapDataVolume
