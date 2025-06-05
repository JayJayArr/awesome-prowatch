SELECT
    FNAME AS 'First Name',
    LNAME AS 'Last Name',
    LOGDEVDESCRP,
    CARDNO,
    CASE
        EVNT_ADDR
        WHEN 400 THEN 'Denied - Unknown Card'
        WHEN 405 THEN 'Denied - Valid Card at an unauthorized Reader'
        WHEN 411 THEN 'Denied - Valid Card, Invalid Time Zone'
        WHEN 500 THEN 'Granted - Local Grant'
        WHEN 501 THEN 'Granted - Host Grant'
        WHEN 508 THEN 'Granted - Opened Door which was already unlocked'
        ELSE 'Generic Event'
    END AS "Event Typ",
    EVNT_DAT AS "Event Time"
FROM
    EV_LOG
WHERE
    YEAR(EVNT_DAT) = 2024
    AND EVNT_ADDR IN (400, 405, 411, 500, 501, 508) --AND LOGDEVDESCRP LIKE '%Lock%'
ORDER BY
    EVNT_DAT --Local Grant = 500
    --Unknown Card = 400
    --Valid Card at an unauthorized Reader = 405
    --Invalid Card Time Zone = 411
    --Host Grant = 501
    --Opened Unlocked Door = 508
