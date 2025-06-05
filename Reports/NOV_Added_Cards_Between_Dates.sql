SELECT
    Year(dbo.Audit_Log.DT) AS 'Jahr',
    MONTH(dbo.Audit_Log.DT) AS 'Monat',
    DAY(dbo.Audit_Log.DT) AS 'Tag',
    BADGE.LNAME AS 'Last Name',
    BADGE.FNAME AS 'First Name',
    BADGE_V.BADGE_EMPLOYEE_ID AS 'Employee ID'
FROM
    [PWNT].[dbo].[AUDIT_LOG]
    INNER JOIN [PWNT].[dbo].[BADGE_C] ON AUDIT_LOG.KEY1 = BADGE_C.ID
    INNER JOIN [PWNT].[dbo].[BADGE] ON BADGE.ID = BADGE_C.ID
    INNER JOIN [PWNT].[dbo].[BADGE_V] ON BADGE_V.ID = BADGE.ID
WHERE
    OPERATION = 1 --Karte hinzugefügt
    AND TABLE_NAME = 'BADGE_C'
    AND Year(dbo.Audit_Log.DT) >= '2021'
    AND (
        WRKST = 'PHCHBS-W31096' --Produktions Büro Stein
    )
ORDER BY
    Year(dbo.Audit_Log.DT),
    MONTH(dbo.Audit_Log.DT),
    DAY(dbo.Audit_Log.DT)
