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