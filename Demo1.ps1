# A Person enters the session lets record their properties

    $Jason = [pscustomobject]@{
        Name           = "Jason";
        Height         = 72;
        Haircolor      = "Brown";
        CurrentSession = "PowerShell";
        IsPresenter    = $true;
        Company        = "NetApp";
        JobTitle       = "Professional Services Consultant"
    }

    $Jason

#
#Another Person enters session

    $Joseph = [pscustomobject]@{
        Name           = "Joseph"
        Height         = 69
        Haircolor      = "Brown"
        CurrentSession = "PowerShell"
        IsPresenter    = $true
        Company        = "NetApp"
        JobTitle       = "Professional Services Engineer"
    }

    $Joseph

#
#I need a place to hold all of these people.

    $sessionAttendees = @()
    $sessionAttendees += $Jason
    $sessionAttendees += $Joseph
    $sessionAttendees

#
#I now have an array of objects. I can validate this by running the following method

    $sessionAttendees.GetType()

#
#I can filter the array using the where-object statement

    $sessionAttendees | Where-Object { $_.Name -eq "Jason" }

#
#I can put jason back into a variable

    $JasonObj = $sessionAttendees | Where-Object { $_.Name -eq "Jason" }
    $JasonObj

#
#I can see that Jason's name is also an object (string)

    $JasonObj.Name.GetType()

#
#I can update a property of Jason and it will reflect back to the object in the array, as they are one in the same.
    $JasonObj.Company = "The Best Company... NETAPP"
    $JasonObj

    $sessionAttendees

    $JasonObj.Company = "NetApp"
    $JasonObj

#
# That was fun but I need a way to make these people faster as there are a lot of us. Lets create a function

    function New-Person {
        param(
            $Name,
            $Height,
            $HairColor,
            $CurrentSession,
            $IsPresenter,
            $Company,
            $JobTitle
        )

        [pscustomobject]@{
            TypeName       = 'NetApp.Insight.Attendee'
            Name           = $Name
            Height         = $Height
            Haircolor      = $HairColor
            CurrentSession = $CurrentSession
            IsPresenter    = $IsPresenter
            Company        = $Company
            JobTitle       = $JobTitle
        }
    }

#