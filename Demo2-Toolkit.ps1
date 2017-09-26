#region Offline volumes

    ## Show the toolkit help for that command
    Get-NcHelp -Cmdlet Get-NcVol

    ## This asks the cluster for all volumes, once PowerShell receives them it sends them over the pipeline
    ## it then queries each object to see if it is offline
    Get-NcVol | Where-Object { $_.State -eq "offline" }
    Get-NcVol | Where-Object { $_.VolumeStateAttributes.State -eq "offline" }

    ## This tells the cluster (mgwd) to query it's local vldb for offline volumes.
    $queryAttributes = Get-NcVol -Template -Fill
    $queryAttributes.VolumeStateAttributes.State = 'offline'
    Get-NcVol -Query $queryAttributes

    ## Another way to do the same
    Get-NcVol -Query @{ State = "offline" }

    ## Set Volumes to Online
    Get-NcVol -Query @{ State = "offline" } | Set-NcVol -Online

    ## Set offline again
    Get-NcVol -Vserver vs_doug -Name test | Set-NcVol -Offline

#endregion

#region New Volume

    ## Create new volume
    ## The new volume creation command requires the aggregate name informataion. Lets see what aggregates there are and how much space there is available.
    Get-NcAggr

    ## Does this volume exist?
    Get-NcVol -Name 'InsightVol1' -Vserver InsightSVM

    ## Let's create the new volume
    New-NcVol -VserverContext 'InsightSVM' -Name 'InsightVol1' -JunctionPath '/InsightVol1' -Aggregate 'n1_aggr1' -Size '1g'

    ## Let's create another volume, this time using 'splatting'
    $params = @{
        Name         = 'InsightVol2'
        JunctionPath = '/InsightVol2'
        Aggregate    = 'n1_aggr1'
        Size         = '1g'
    }

    New-NcVol @params -VserverContext 'InsightSVM'

    ## Bulk add volumes by using the ForEach-Object cmdlet
    'InsightVol3', 'InsightVol4' | ForEach-Object {
        New-NcVol -Name $_ -VserverContext 'InsightSVM' -JunctionPath "/$_" -Aggregate 'n1_aggr1' -Size '1g'
    }

#endregion

#region Resize volumes

    Get-NcVol -Vserver InsightSVM | Where-Object {-not $_.VolumeStateAttributes.IsVserverRoot -and $_.Used -gt 4}

    Get-NcVol -Vserver InsightSVM | Where-Object {-not $_.VolumeStateAttributes.IsVserverRoot -and $_.Used -gt 4} | Set-NcVolSize -NewSize +20%

#endregion

#region Volume bulk delete

    ## Delete the volumes
    Get-NcVol -Name 'InsightVol1', 'InsightVol2', 'InsightVol3', 'InsightVol4' -Vserver 'InsightSVM' | Dismount-NcVol | Set-NcVol -Offline | Remove-NcVol -Whatif
    Get-NcVol -Name 'InsightVol1', 'InsightVol2', 'InsightVol3', 'InsightVol4' -Vserver 'InsightSVM' | Dismount-NcVol | Set-NcVol -Offline | Remove-NcVol -Confirm:$false

    #::> vol unmount -vserver InsightSVM -volume InsightVol1
    #::> vol offline -vserver InsightSVM -volume InsightVol1
    #::> vol delete -vserver InsightSVM -volume InsightVol1

    Get-NcVol -Vserver 'InsightSVM'

#endregion

#region Sample new volume functions

    function New-NtapDataVolume1 {
        param (
            [string]$Name,
            [string]$Vserver,
            [string]$Aggregate,
            [string]$Size
        )

        New-NcVol -VserverContext $Vserver -Name $Name -Aggregate $Aggregate -Size $Size
    }

    function New-NtapDataVolume2 {
        param (
            [string]$Name,
            [string]$Vserver,
            [string]$Aggregate,
            [string]$Size
        )

        if (-not (Get-NcVserver -Vserver $Vserver)) {
            Write-Error -Message "Vserver not found: $Vserver"
            return
        }

        if (-not (Get-NcAggr -Name $Aggregate -EA Ignore)) {
            Write-Error -Message "Aggregate not found: $Aggregate"
            return
        }

        if (Get-NcVol -Name $Name -Vserver $Vserver) {
            Write-Error -Message "Volume exists: $Volume"
            return
        }

        New-NcVol -VserverContext $Vserver -Name $Name -Aggregate $Aggregate -Size $Size
    }

#endregion
