-- Find Clearance Codes which might be Problematic according to the Count per Person
SELECT
    *
FROM
    (
        SELECT
            lname,
            fname,
            COUNT(*) AS [Assigned Clearance Codes ]
        FROM
            badge b
        LEFT OUTER JOIN badge_cc bcc
            ON b.id = bcc.ID
        GROUP BY
            lname,
            fname
    ) x
WHERE
    [Assigned Clearance Codes ]>=12;
-- Change to 12 or 32 depending on system options setting
--2nd part
-- If this yields results investigate closer with the following:
WITH x AS (
    SELECT
        PANEL_ID AS Panel,
        CARDNO AS Cardnumber,
        SEQ AS Sequence,
        C.Descrp AS ClearanceCodes,
        COUNT(SEQ) OVER (PARTITION BY PANEL_ID,
        CARDNO) AS TotalCCPerCardPerPanel
    FROM
        DNV_PANEL_CARD_ACCLEV dnv
    INNER JOIN clear c
        ON dnv.CLEAR_COD = c.id
) SELECT
    *
FROM
    x
WHERE
    TotalCCPerCardPerPanel > 12-- Change to 12 or 32 depending on system options setting

ORDER BY
    Cardnumber,
    ClearanceCodes;
-- 3rd part
-- To find the Clearance Codes assigned to a specific card found above
SELECT
    bc.id,
    bc.cardno,
    bc.STAT_COD,
    c.DESCRP,
    c.ID
FROM
    badge_c bc
INNER JOIN badge_cc bcc
    ON bc.id = bcc.id
INNER JOIN clear c
    ON bcc.CLEAR_COD = c.id
WHERE
    bc.cardno = '114734'--Adjust for the relevant Card

ORDER BY
    c.descrp
