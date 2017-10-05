#region Offline volumes

    ## This asks the cluster for all volumes, once PowerShell receives them it sends them over the pipeline
    ## it then queries each object to see if it is offline
        Get-NcVol | Where-Object { $_.State -eq "offline" }
        Get-NcVol | Where-Object { $_.VolumeStateAttributes.State -eq "offline" }

    ## This tells the cluster (mgwd) to query it's local vldb for offline volumes.
        $queryAttributes = Get-NcVol -Template -Fill
        $queryAttributes

        $queryAttributes.VolumeStateAttributes.State = 'offline'
        Get-NcVol -Query $queryAttributes

    ## Another way to do the same
        Get-NcVol -Query @{ State = "offline" }

    ## Set Volumes to Online
        Get-NcVol -Query @{ State = "offline" } | Set-NcVol -Online

    ## Set offline again
        Get-NcVol -Vserver InsightSVM -Name testoffline | Set-NcVol -Offline

    ## Show the toolkit help for that command
        Get-NcHelp -Cmdlet Get-NcVol

#endregion

#region New Volume

    ## Create new volume
    ## The new volume creation command requires the aggregate name information. Lets see what aggregates there are and how much space there is available.
        Get-NcAggr

    ## Create volume 'InsightVol1' .. Does this volume exist?
        Get-NcVol -Name 'InsightVol1' -Vserver InsightSVM

    ## Let's create the new volume
        New-NcVol -VserverContext 'InsightSVM' -Name 'InsightVol1' -JunctionPath '/InsightVol1' -Aggregate 'n1_aggr1' -Size '1g'

    ## Bulk add volumes by using the ForEach-Object cmdlet
        'InsightVol2', 'InsightVol3' | ForEach-Object {
            New-NcVol -Name $_ -VserverContext 'InsightSVM' -JunctionPath "/$_" -Aggregate 'n1_aggr1' -Size '1g'
        }

    ## List our new volumes
        Get-NcVol -Vserver InsightSVM

#endregion

#region Resize volumes

    Get-NcVol -Vserver InsightSVM | Where-Object { -not $_.VolumeStateAttributes.IsVserverRoot -and $_.Used -gt 4 }

    Get-NcVol -Vserver InsightSVM | Where-Object {-not $_.VolumeStateAttributes.IsVserverRoot -and $_.Used -gt 4} | Set-NcVolSize -NewSize +20%

#endregion
