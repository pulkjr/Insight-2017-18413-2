#region import/credentials

    ## First we must import the module
    Import-Module DataONTAP

    Remove-NcCredential -Name den-cdot

    ## Now we need to connect to a cluster
    $controller = Connect-NcController -Name den-cdot -Credential (Get-Credential)

    ## This creates a global variable with the connection object
    $Global:CurrentNcController

    ## Using cached credentials, we can omit the -Credential parameter
    Get-NcCredential -Name den-cdot
    Add-NcCredential -Name den-cdot -Credential (Get-Credential)
    Get-NcCredential -Name den-cdot

    $controller = Connect-NcController -Name den-cdot

#endregion

#region Help

    # View the commands in the Data Ontap Module dealing with volumes
    Get-Command -Module DataONTAP -Name *vol*

    # Show the help for that command
    Get-Help New-NcVol -Full

    # Show the toolkit for that command
    Get-NcHelp -Cmdlet Get-NcVol

    ## Show the webhelp
    Show-NcHelp

#endregion

#region Volume and properties

    ## Gather all volumes into the $vols variable
    $vols = Get-NcVol

    $vols

    ## Let's just look at one of them
    $vol = $vols | Select-Object -First 1

    $vol

    $vol | Get-Member

    $vol.VolumeStateAttributes

#endregion

#region Offline volumes

    # This asks the cluster for all volumes, once PowerShell receives them it sends them over the pipeline
    # it then queries each object to see if it is offline
    Get-NcVol | Where-Object { $_.State -eq "Offline" }

    # This tells the cluster (mgwd) to query it's local vldb for offline volumes.
    $queryAttributes = Get-NcVol -Template -Fill
    $queryAttributes.VolumeStateAttributes.State = 'Offline'

    Get-NcVol -Query $queryAttributes

    Get-NcVol -Query @{ State = "Offline" }

    # Set Volume to Online
    Get-NcVol -Query @{ State = "Offline" } | Set-NcVol -Online

#endregion

#region New Volume

    ## Create new volume
    # The new volume creation command requires the aggregate name informataion. Lets see what aggregates there are and how much space there is available.
    Get-NcAggr

    # Does this volume exist?
    Get-NcVol -Name 'InsightVol1'

    ## Using splatting, let's create that new volume
    $params = @{
        Name          = 'InsightVol1'
        JunctionPath  = '/InsightVol1'
        Aggregate     = 'n1_aggr1'
        SecurityStyle = 'unix'
        Size          = '10g'
    }

    New-NcVol @params -VserverContext InsightSVM

#endregion

#region Resize volumes

    Get-NcVol -Vserver InsightSVM | Where-Object {-not $_.VolumeStateAttributes.IsVserverRoot -and $_.Used -gt 4}

    Get-NcVol -Vserver InsightSVM | Where-Object {-not $_.VolumeStateAttributes.IsVserverRoot -and $_.Used -gt 4} | Set-NcVolSize -NewSize +20%

#endregion

#region Volume bulk add/delete

    ##
    'InsightVol1', 'InsightVol2', 'InsightVol3' | ForEach-Object {
        New-NcVol -Name $_ -VserverContext InsightSVM -JunctionPath "/$_" -Aggregate n1_aggr1 -SecurityStyle unix -Size 10g
    }

    ##
    Get-NcVol -Name 'InsightVol1', 'InsightVol2', 'InsightVol3' -Vserver InsightSVM | Dismount-NcVol | Set-NcVol -Offline | Remove-NcVol -Confirm:$false

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

    function New-NtapDataVolume1 {
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

#region Better new volume function

    . .\New-NtapDataVolume3.ps1

    $controller = Connect-NcController -Name den-cdot
    New-NtapDataVolume3 -Controller $controller -Name 'TestCifs1' -Vserver InsightSVM -Size 10g -Application CIFS -ErrorVariable NewVolError

    Get-NcVol -Name TestCifs1 -Vserver InsightSVM

#endregion