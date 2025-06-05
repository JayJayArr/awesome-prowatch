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
DECLARE
@startTime Datetime
DECLARE
@endTime Datetime
SET
    @startTime = CONVERT(date, getdate() -7)
SET
    @endTime = CONVERT(date, getdate())
SELECT
    *
FROM
    (
        SELECT
            site,
            count (site) AS ValidReads,
            'Day_of_week' = (
                CASE
                    datepart(weekday, EVNT_DAT)
                    WHEN 1 THEN 'Sunday'
                    WHEN 2 THEN 'Monday'
                    WHEN 3 THEN 'Tuesday'
                    WHEN 4 THEN 'Wednesday'
                    WHEN 5 THEN 'Thursday'
                    WHEN 6 THEN 'Friday'
                    WHEN 7 THEN 'Saturday'
                END
            )
        FROM
            (
                SELECT
                    ev_log.CARDNO,
                    ev_log.PANEL_DESCRP,
                    panel.Site,
                    ev_log.evnt_dat,
                    ROW_NUMBER() over (
                        PARTITION BY ev_log.cardno,
                        datepart(weekday, ev_log.evnt_dat)
                        ORDER BY
                            ev_log.cardno
                    ) AS RowID
                FROM
                    ev_log
                    INNER JOIN panel ON ev_log.panel_descrp = panel.DESCRP --join panel to get Site
                WHERE
                    EVNT_DESCRP LIKE '%Grant%'
                    AND ev_log.EVNT_DAT BETWEEN @startTime AND @endTime
            ) AS "collectiontable"
        WHERE
            collectiontable.rowID = 1 --get unique valid reads from collectiontable
        GROUP BY
            SITE,
            datepart(weekday, evnt_dat)
    ) AS "Source" PIVOT (
        sum(ValidReads) FOR Day_of_week IN (
            [Sunday],
            [Monday],
            [Tuesday],
            [Wednesday],
            [Thursday],
            [Friday],
            [Saturday]
        )
    ) AS "pivottable"
