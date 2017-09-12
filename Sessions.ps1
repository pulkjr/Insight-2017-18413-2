# Create a Person Object
$person = New-Object -TypeName pscustomobject -Property @{
    Name = "Jason";
    Height = 100;
    Haircolor = "grey";
    CurrentSession = "General"
}

#Import Insight atendees and session schedules
$SessionsSchedule = Import-Csv -Path 

#Display attendees signed up for sessions
$SessionsSchedule

#Get a list of distinct attendees
$SessionsSchedule | Select-Object -Unique Name

#Place Attendees in a variable
$InsightAttendeesArr = $SessionsSchedule | Select-Object -Unique Name

#Find All attendees slotted for this session
$InsightAttendeesArr | Where-Object {$_.Session -eq "746"}

#Mark all attendees as currently present in session
foreach($attendee in $InsightAttendeesArr | Where-Object {$_.Session -eq "746"}){
        $attendee.Status = "In Session"
}