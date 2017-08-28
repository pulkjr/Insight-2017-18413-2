$Session = $Insight | Where-Object {$_.ID -eq "18413-2"}
# Find the Session within Insight Array


# Find Object Jason within the Sessions Array
$ColeObj = $Session.Members | Where-Object {$_.Name -eq "Jason"}

# Objects also may have methods that other objects may be sent into
$ColeObj.DrinkBeer()

# Now you may want to do this many times. In this case you may want to use an array and foreach until it is empty.
$Beers = Get-AllBeers

Foreach($Beer in 0..9){
    $ColeObj.DrinkBeer()
}

# Let us now create a script that will allow us to drink without getting drunk because we have to present tomorrow.
.\invoke-GetDrunk.ps1 -Beers $Beers -Person $ColeObj

# That script has too many limitations on the location where I can drink from. I want to walk around and drink everywhere. Let's encapsulate this into a function and add it to a module.
# Check if the module is loaded
Get-Module
# Import the module
Import-Module Drinking

# Change directories
pwd # Mandaly
cd \MGM
Invoke-GetDrunk -Beers $Beers -Person $ColeObj

# The previous examples were working on objected already instantiated and local to the system. We now want to connect to a remote system
# In order to do this we will need to create a connection and save it.
Connect-NcController NTAPPosh1

# This creates a globally scoped variable called currentNcController
$Global:currentNcController

# Using the global variable is fine if you are only working with one system but if you want to deal with multiple systems with different credentials
# you will either need to create your own variables or cache your credentials
$cluster1 = Connect-NcController NTAPPosh1

# Cache Credential
Add-NcCredential

# View Credential Cache
Get-NcCredential

# View the commands in the Data Ontap Module dealing with Volumes
Get-Command -Module Dataontap -Name *vol*

# Show the Help for that command
Get-Help New-NcVol

# Show the Webhelp for that Command
Show-NcHelp New-NcVol

# The New volume creation command requires the aggregtate name informataion. Lets see what aggregates there are and how much space there is available.
Get-NcAggr

# Does this volume exist?
Get-NcVol -Name $VolumeName

# This asks the cluster for all volumes, once PowerShell receives them it sends them over the pipeline
# it then queries each object to see if it is offline
Get-NcVol | Where-Object{$_.State -eq "Offline"}

# This tells the cluster (mgwd) to query it's local vldb for offline volumes.
Get-NcVol -Query @{State = "Offline"}

# Set Volume to Online
Get-NcVol -Query @{State = "Offline"} | Set-NcVol -Online

Function New-StandardVolume1 {
    param(

    )
    New-NcVol 
}
New-StandardVolume1

#
Function New-StandardVolume2 {
    param(

    )
    do something
    more
}
New-StandardVolume2