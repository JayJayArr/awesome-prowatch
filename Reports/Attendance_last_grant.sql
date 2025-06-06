DECLARE
@UserDateDATE;

SET
    @UserDate = '2024-12-14';

-- Hier kannst du das Datum manuell eingeben
SELECT
    DISTINCTLNAME,
    FNAME,
    CARDNO,
    MAX(EVNT_DAT) AS [Zutritt um]
FROM
    EV_LOG
    LEFT OUTER JOIN LOGICAL_DEV ON EV_LOG.LOGDEVID = LOGICAL_DEV.ID
WHERE
    CAST(EVNT_DAT AS DATE) = @UserDate
    AND EVNT_DESCRPLIKE '%Grant%'
GROUP BY
    CAST(EVNT_DAT AS DATE),
    LNAME,
    FNAME,
    CARDNO
ORDER BY
    LNAMe,
    FNAME,
    CARDNO,
    MAX(EVNT_DAT)
