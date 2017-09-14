# In this example we are building a person object. Think of the properties of a physical person.
# Name, Heigh, Haircolor... 
# You set these by either using the Add-Members function or by adding the members during instantiation.
    $Jason = [pscustomobject]@{
        Name           = "Jason";
        Height         = 72;
        Haircolor      = "Brown";
        CurrentSession = "PowerShell";
        IsPresenter    = $true;
        Company        = "NetApp";
        JobTitle       = "Professional Services Consultant"
    }

# With the object now created lets display the object and list the properties.
    $Jason
    $Jason.GetType()
    $Jason | Get-Member

# Even Properties have types. Notice that we didn't specify the types of these properties!
# Remember types can cause you problems if you let PowerShell decide for you.
# PowerShell is not strongly typed!
    $Jason.Name.GetType()
    $Jason.Name | Get-Member

    $Jason.Height.GetType()
    $Jason.Height
    $Jason.Height * 2
    $Jason.Height = '72'
    $Jason.Height.GetType()
    $Jason.Height * 2
    $Jason.Height = [int]'72'
    $Jason.Height = [int]'72a'
    $Jason.Height.GetType()

    $Jason.IsPresenter.GetType()


# Let's instantiate another person

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
# These objects are nice by themselves but now these people are attending a great insight session. Lets put them together in an array.

# This command can be used to instantiate an array. 
    $sessionAttendees = @()
    $sessionAttendees.gettype()
# Again everything is an object in PowerShell, so lets show the methods and properties of an array
    Get-Member -InputObject $sessionAttendees

# Now that we have an array let's add an object to it.
    $sessionAttendees += $Jason
    $sessionAttendees += $Joseph

# We can now see the two attendees of this session
    $sessionAttendees

# We now have an array of objects.
    $sessionAttendees.GetType()

# I can view the members of the objects by sending each object over the pipline and retrieving the members
    $sessionAttendees | Get-Member

# Notice that when I view the members of the sessionAttendees object that this is an array type and not a pscustomobject.
    Get-Member -InputObject $sessionAttendees

# I can now use the pipeline to filter the objects that I see on screen or that I send to the next command over the pipeline.
# This is done using the Where-Object function.
    $sessionAttendees | Where-Object { $_.Name -eq "Jason" }

# I can now put Jason into a difference variable and show the content.
    $JasonObj = $sessionAttendees | Where-Object { $_.Name -eq "Jason" }
    $JasonObj

# I can update a property of Jason and it will reflect back to the object in the array, as they are one in the same.
    $JasonObj.Company = "The Best Company... NETAPP"
    $JasonObj

    $sessionAttendees  | Where-Object { $_.Name -eq "Jason" }

    $JasonObj.Company = "NetApp"
    $JasonObj

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

# Now how does this apply to NetApp?