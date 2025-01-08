DECLARE @startTime Datetime
DECLARE @endTime Datetime

SET @startTime = convert( date, getdate()-60 )
SET @endTime = convert( date, getdate() )

SELECT  
count (site) as ValidReads, 
DAY(EVNT_DAT)as DAYoftheMonth,
EVNT_DAT
FROM 
    (
    SELECT ev_log.CARDNO,
        ev_log.PANEL_DESCRP, 
        panel.Site, 
        ev_log.evnt_dat,
        ROW_NUMBER() over 
            (PARTITION BY ev_log.cardno, ev_log.evnt_dat  
            ORDER BY ev_log.cardno) as RowID
    FROM ev_log
        inner join panel on ev_log.panel_descrp = panel.DESCRP --join panel to get Site
    WHERE EVNT_DESCRP like '%Grant%'
        and ev_log.EVNT_DAT between @startTime and @endTime
    ) as "collectiontable"

WHERE collectiontable.rowID =1 --get unique valid reads from collectiontable

AND Site = 'CHGE-AAA'
AND MONTH(EVNT_DAT) = 1
AND YEAR(EVNT_DAT) = 2023
GROUP BY DAY(EVNT_DAT), EVNT_DAT