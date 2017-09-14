if (-not (Get-Module -Name DataONTAP)) {
    Import-Module -Name DataONTAP
}

. $PSScriptRoot\Public\New-NtapDataVolume.ps1

filter Skip-RootVol {
    if (-not $_.VolumeStateAttributes.IsVserverRoot -and -not $_.VolumeStateAttributes.IsNodeRoot) {
        return $_
    }
}

Function Get-NtapDataVolume {
    param(
        [Parameter(Mandatory)]
        [NetApp.Ontapi.AbstractController]$Controller,

        [Parameter(Mandatory)]
        [string]$Vserver,

        [Parameter()]
        [string]$Name
    )

    Get-NcVol @PSBoundParameters | Skip-RootVol | ForEach-Object {
        $vol = $_ | Select-Object -Property *
        $vol.psobject.TypeNames.Insert(0, 'ModuleDemo.Volume')

        $vol
    }
}
