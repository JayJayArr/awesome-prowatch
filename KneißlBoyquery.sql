DECLARE @CheckedIn AS int
SET @CheckedIn = 0

 

SELECT LNAME AS Nachname, FNAME AS Vorname, CARDNO AS Personalnummer, EVNT_DAT AS Zeitbuchung, (case
    WHEN EVNT_DAT = min(EVNT_DAT) THEN 'IN'
    WHEN EVNT_DAT = max(EVNT_DAT) THEN 'OUT'
end)  FROM EV_LOG
WHERE LOCATION = 'C4R01 E03 MA Eingang' 
AND LNAME = 'Kneissl'																				--insert Last Name		
AND FNAME = 'Lukas'																					--insert First Name
AND EVNT_DAT BETWEEN '2023-08-21 00:00:00.000' AND '2023-08-22 00:00:00.000'						--insert Date & Time of interest (yyyy-mm-dd hh:mm:ss.000)


--Functional solution
SELECT CARDNO AS Personalnummer, min(EVNT_DAT) AS INTIME, max(EVNT_DAT) AS OUTTIME FROM EV_LOG
WHERE LOCATION = 'C4R01 E03 MA Eingang' 
AND EVNT_DAT BETWEEN '2023-08-21 00:00:00.000' AND '2023-08-22 00:00:00.000'						--insert Date & Time of interest (yyyy-mm-dd hh:mm:ss.000)
GROUP BY CARDNO




