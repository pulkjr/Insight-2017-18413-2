# A Person enters the session lets record their properties
$Jason = New-Object -TypeName pscustomobject -Property @{
    Name = "Jason";
    Height = 100;
    Haircolor = "grey";
    CurrentSession = "PowerShell";
    Presenter = $true;
    Company = "NetApp";
    JobTitle = "Professional Services Consultant"
}
$Jason
#Another Person enters session

$Joseph = New-Object -TypeName pscustomobject -Property @{
    Name = "Joseph"
    Height = 69
    Haircolor = "Brown"
    CurrentSession = "PowerShell"
    Presenter = $true
    Company = "NetApp"
    JobTitle = "Professional Services Engineer"
}
$Joseph

#I need a place to hold all of these people. 
$sessionArr = @()
$sessionArr += $Jason
$sessionArr += $Joseph
$sessionArr

#I now have an array of objects. I can validate this by running the following method
$sessionArr.gettype()

#I can filter the array using the where-object statement
$sessionArr | Where-Object{$_.Name -eq "Jason"}

#I can put jason back into a variable
$JasonObj = $sessionArr | Where-Object{$_.Name -eq "Jason"}
$JasonObj

#I can see that jasons name is also an object
$JasonObj.Name.gettype()

#I can update a property of Jason and it will reflect back to the object in the array, as they are one in the same.
$JasonObj.Company = "The Best Company... NETAPP"
$JasonObj
$sessionArr
$JasonObj.Company = "NetApp"

# That was fun but I need a way to make these people faster as there are a lot of us. Lets create a function
function New-Person{
    param(
        $Name,
        $Height,
        $HairColor,
        $CurrentSession,
        $Presenter,
        $Company,
        $JobTitle,
        $MaxBeers = 10
    )
    $returnObj = New-Object -TypeName pscustomobject -Property @{
        Name = $Name
        Height = $Height
        Haircolor = $HairColor
        CurrentSession = $CurrentSession
        Presenter = $Presenter
        Company = $Company
        JobTitle = $JobTitle
        MaxBeers = $MaxBeers
    }
    $returnObj.TypeNames.Add('NetApp.Insight.Attendee')

    $returnObj
}