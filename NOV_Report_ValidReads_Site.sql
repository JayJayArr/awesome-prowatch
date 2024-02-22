/**
    @file: Report ValidReads BY Site
    @author: Scott Thompson
    @version V1.01
    @brief   report valid reads FROM all sites over the last 7 weekdays, grouped BY weekdays

   change history:
              ST    Creation
   25.10.2022 JR    readability, fix getdate to calendar date
 
   @date    25/10/2022
**/

DECLARE @startTime Datetime
DECLARE @endTime Datetime

SET @startTime = convert( date, getdate()-7 )
SET @endTime = convert( date, getdate() )

SELECT *
FROM
(
    SELECT site, 
        count (site) as ValidReads, 
        'Day_of_week'= (case datepart(weekday,EVNT_DAT)
            WHEN 1 THEN 'Sunday'
            WHEN 2 THEN 'Monday'
            WHEN 3 THEN 'Tuesday'
            WHEN 4 THEN 'Wednesday'
            WHEN 5 THEN 'Thursday'
            WHEN 6 THEN 'Friday'
            WHEN 7 THEN 'Saturday'
            end) 
    FROM 
        (
        SELECT ev_log.CARDNO,
            ev_log.PANEL_DESCRP, 
            panel.Site, 
            ev_log.evnt_dat,
            ROW_NUMBER() over 
                (PARTITION BY ev_log.cardno, datepart(weekday,ev_log.evnt_dat)  
                ORDER BY ev_log.cardno) as RowID
        FROM ev_log
            inner join panel on ev_log.panel_descrp = panel.DESCRP --join panel to get Site
        WHERE EVNT_DESCRP like '%Grant%'
            and ev_log.EVNT_DAT between @startTime and @endTime
        ) as "collectiontable"

    WHERE collectiontable.rowID =1 --get unique valid reads from collectiontable
    GROUP BY SITE, datepart(weekday,evnt_dat)
) as "Source"

PIVOT
(
    sum(ValidReads)
    for Day_of_week in ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
) as "pivottable"