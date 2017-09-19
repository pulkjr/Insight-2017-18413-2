function New-NtapDataVolume {
    <#
        .SYNOPSIS
            Create a new ONTAP data volume based on the protocol specified.

        .DESCRIPTION
            Create a new ONTAP data volume with appropriate settings applied based on the protocol specified.

        .PARAMETER Controller
            The controller object

        .PARAMETER Name
            The name of the volume

        .PARAMETER Vserver
            The SVM name to create the volume in

        .PARAMETER Size
            The size of the volume

        .PARAMETER Protocol
            The protocol the volume will be accessed by

        .EXAMPLE
            PS C:\> $controller = Connect-NcController -Name vm-cdot -Credential (Get-Credential)
            PS C:\> New-NtapDataVolume -Controller $controller -Name CifsTest1 -Vserver InsightSVM -Size 10g -Protocol CIFS

            Connect to the cluster 'vm-cdot' and creates the specified volume.

        .INPUTS
            none

        .OUTPUTS
            DataONTAP.C.Types.Volume.VolumeAttributes
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
        [string]$Aggregate,

        [Parameter(Mandatory)]
        [string]$Size,

        [Parameter(Mandatory)]
        [ValidateSet('CIFS', 'NFS')]
        [string]$Protocol
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
        Name           = $Name
        VserverContext = $Vserver
        Aggregate      = $Aggregate
        JunctionPath   = "/$Name"
        Size           = $Size
    }

    switch -exact ($Protocol) {
        'CIFS' {
            $params.Add('SecurityStyle', 'ntfs')
        }
        'NFS' {
            $params.Add('SecurityStyle', 'unix')
        }
    }

    New-NcVol @params -Controller $Controller
}
