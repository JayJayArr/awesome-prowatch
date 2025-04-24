DECLARE @startTime Datetime DECLARE @endTime Datetime
SET
    @startTime = CONVERT(date, getdate() -60)
SET
    @endTime = CONVERT(date, getdate())
SELECT
    count (site) AS ValidReads,
    DAY(EVNT_DAT) AS DAYoftheMonth,
    EVNT_DAT
FROM
    (
        SELECT
            ev_log.CARDNO,
            ev_log.PANEL_DESCRP,
            panel.Site,
            ev_log.evnt_dat,
            ROW_NUMBER() over (
                PARTITION BY ev_log.cardno,
                ev_log.evnt_dat
                ORDER BY
                    ev_log.cardno
            ) AS RowID
        FROM
            ev_log
            INNER JOIN panel ON ev_log.panel_descrp = panel.DESCRP --join panel to get Site
        WHERE
            EVNT_DESCRP LIKE '%Grant%'
            AND ev_log.EVNT_DAT BETWEEN @startTime
            AND @endTime
    ) AS "collectiontable"
WHERE
    collectiontable.rowID = 1 --get unique valid reads from collectiontable
    AND Site = 'CHGE-AAA'
    AND MONTH(EVNT_DAT) = 1
    AND YEAR(EVNT_DAT) = 2023
GROUP BY
    DAY(EVNT_DAT),
    EVNT_DAT