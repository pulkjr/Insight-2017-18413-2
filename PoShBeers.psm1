Function New-Person{
    param(
        [String]$Name,
        [int]$Age,
        $Height,
        [bool]$Presenter,
        $MaxBeers,
        [bool]$isDrunk = $false
    )
    $Person = New-Object -TypeName pscustomobject -Property @{
        Name = $Name;
        Age = $Age;
        Height = $Height;
        Presenters = $Presenter;
        MaxBeers = $MaxBeers
        CurrentBeers = 0
        isDrunk = $isDrunk
    }
    $Person | Add-Member -MemberType ScriptMethod -Name Puke -Value {
        Write-Host -ForegroundColor DarkMagenta "PUKE! $#%U(...FEW...$@#$*E(U(#@I)IE*UR#*$#%Y^"
    }
    $DrinkBeer = {
        If($this.isDrunk){
            $this.Puke()
        }
        else{
            if(($this.MaxBeers - $this.CurrentBeers) -gt 0){
                $this.CurrentBeers++
            }
            if(($this.MaxBeers - $this.CurrentBeers) -eq 0){
                $this.isDrunk = $true
            }
        }
    }   
    
    $Person | Add-Member -MemberType ScriptMethod -Name DrinkBeer -Value $DrinkBeer
    
    $Person
}
Function New-InsightSession{
    param(
        [String]$id,
        [String]$Name,
        [String]$Location
    )
    $Session = New-Object -TypeName pscustomobject -Property @{ID = $id;
        Name = $Name;
        Location = $Location;
        Presenters = @();
        Members = @()
    }

    $Jason = New-Person -Name "Jason" -Age 37 -Height 73 -Presenter $true -MaxBeers 10
    $Joe = New-Person -Name "Joseph" -Age 32 -Height 69 -Presenter $true -MaxBeers 5

    $Session.Presenters += $Joe
    $Session.Presenters += $Jason

    $Session.Members += $Jason
    $Session.Members += $Joe
    $Session.Members += New-Person -Name "Pen" -Age 45 -Height 65 -Presenter $false -MaxBeers 2

    Return $Session
}

Function Invoke-GetDrunk{
    Param(
        $Beers,
        $Person
    )
    if($person.isDrunk){
        throw "Person Already Drunk!"
    }
    Foreach($Beer in $Beers){
        if($person.currentBeers -gt 0){
            $percentDrunk = ($person.currentBeers/$person.MaxBeers) * 100
        }
        else{
            $percentDrunk = 0
        }

        if($percentDrunk -lt 25){
            Write-Host -ForegroundColor Green "This beer is great!"
            
        }

        if($percentDrunk -gt 25 -and $percentDrunk -lt 75){
            Write-Host -ForegroundColor Green "Love you MAN!"
            
        }
        if($percentDrunk -gt 75){
            Write-Host -ForegroundColor Red "I'm calling it quits, Have to present PowerShell Tomorrow"
            break
        }
        $Person.DrinkBeer()
        Start-Sleep -Seconds 1
    }

    return $Person
}

$Insight = @()
$Insight += New-InsightSession -id "18413-2" -Name "Microsoft PowerShell for the NetApp Storage Administrator" -Location "NEED"
$Insight += New-InsightSession -id "18404-2" -Name "NetAppDocs Customizing the Health-Check Framework for Your Environment" -Location "NEED"

