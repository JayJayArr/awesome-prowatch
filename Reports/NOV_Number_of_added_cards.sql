SELECT
    Year(dbo.Audit_Log.DT) AS 'Jahr',
    MONTH(dbo.Audit_Log.DT) AS 'Monat',
    COUNT(OPERATION) AS 'Karten_hinzugefügt'
FROM
    [PWNT].[dbo].[AUDIT_LOG]
WHERE
    OPERATION = 1 --Karte hinzugefügt
    AND TABLE_NAME = 'BADGE_C'
    AND Year(dbo.Audit_Log.DT) >= '2020'
    AND (
        WRKST = 'PHCHBS-W31096' --Produktions Büro Stein
    )
GROUP BY
    Year(dbo.Audit_Log.DT),
    MONTH(dbo.Audit_Log.DT)
ORDER BY
    Year(dbo.Audit_Log.DT),
    MONTH(dbo.Audit_Log.DT)