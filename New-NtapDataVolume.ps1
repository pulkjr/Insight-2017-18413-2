function New-NtapDataVolume {
    <#
        .SYNOPSIS
        Short description

        .DESCRIPTION
        Long description

        .PARAMETER Controller
        Parameter description

        .PARAMETER Name
        Parameter description

        .PARAMETER Vserver
        Parameter description

        .PARAMETER Size
        Parameter description

        .PARAMETER Application
        Parameter description

        .EXAMPLE
        An example

        .NOTES
        General notes
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [NetApp.Ontapi.AbstractController]$Controller,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Vserver,

        [Parameter(Mandatory)]
        [string]$Size,

        [Parameter(Mandatory)]
        [ValidateSet('CIFS', 'NFS')]
        [string]$Application
    )

    if (-not (Get-NcVserver -Vserver $Vserver -Controller $controller)) {
        Write-Error -Message "Vserver not found: $Vserver"
        return
    }

    if (-not (Get-NcAggr -Name $Aggregate -Controller $controller -EA Ignore)) {
        Write-Error -Message "Aggregate not found: $Aggregate"
        return
    }

    if (Get-NcVol -Name $Name -Vserver $Vserver -Controller $controller) {
        Write-Error -Message "Volume exists: $Volume"
        return
    }

    $params = @{
        Name         = $Name
        Vserver      = $Vserver
        Aggregate    = $Aggregate
        JunctionPath = "/$Name"
        Size         = $Size
    }

    switch -exact ($Application) {
        'CIFS' {
            $params.Add('SecurityStyle', 'ntfs')
        }
        'NFS' {
            $params.Add('SecurityStyle', 'unix')
        }
    }

    New-NcVol @params -Controller $Controller
}
