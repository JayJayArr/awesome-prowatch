### MVP TnA

- Trigger on the Event log which copies all Grants on one specific Reader to another table
- Secondary table holds following information:
  - datetime of the Event
  - Kind of Event (in or out), in the trigger check if the last Event has been an In Event, if yes it is an Out event, otherwise an in event
  - cardno
  - fname and lname (optional)
- Design a report which calculates the attendance time for each cardno

Restrictions:

- in and out events have to be on the same calendar day
- no notifications whatsoever
- Readers can only be changed in the trigger
- no front end

TODO:

- modify trigger to EV_LOG
- create report
