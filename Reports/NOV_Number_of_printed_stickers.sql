SELECT
    Year(dbo.Audit_Log.DT) AS 'Jahr',
    MONTH(dbo.Audit_Log.DT) AS 'Monat',
    COUNT(OPERATION) AS 'Sticker_gedruckt'
FROM
    [PWNT].[dbo].[AUDIT_LOG]
WHERE
    OPERATION = 8 --cards really printed
    AND Year(dbo.Audit_Log.DT) >= '2020'
GROUP BY
    Year(dbo.Audit_Log.DT),
    MONTH(dbo.Audit_Log.DT)
ORDER BY
    Year(dbo.Audit_Log.DT),
    MONTH(dbo.Audit_Log.DT)