--Requesting which users had a clearance code from which start-date until which end-date and for how long
SELECT
    CLEAR.DESCRP AS CLEARANCECODE,
    KEY2 AS CARDNO,
    BADGE_EMPLOYEE_ID,
    BROKER_SITE_CODE_EXT,
    DT,
    CASE
        OPERATION
        WHEN 1 THEN 'Add'
        WHEN 4 THEN 'Remove'
    END AS OPERATION,
    DATEDIFF(
        dayofyear,
        Lag(DT, 1) OVER(
            PARTITION BY KEY2
            ORDER BY
                DT
        ),
        DT
    ) AS 'Days since last Action'
FROM
    [PWNT].[dbo].[AUDIT_LOG] FULL
    OUTER JOIN CLEAR ON AUDIT_LOG.KEY3 = CLEAR.ID FULL
    OUTER JOIN BADGE_V ON BADGE_V.ID = AUDIT_LOG.KEY1
WHERE
    AUDIT_LOG.TABLE_NAME = 'BADGE_CC'
    AND CLEAR.DESCRP = 'All Access'
ORDER BY
    CARDNO,
    DT