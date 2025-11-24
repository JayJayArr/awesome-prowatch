/**Script to create new cards in a ProWatch System by creating them 
with bulk badge add and overwriting them 
with data from a csv inserted into a "translation-table"
in this case the translation table is called "Import" and contains 4 Columns in the given order: FNAME, LNAME, CARDNOOLD, CARDNONEW
*/
USE PWNT;

GO
    -- Import new Cardnumber over existing
UPDATE
    BADGE_C
SET
    BADGE_C.CARDNO = Import.CARDNONEW
FROM
    BADGE_C
    INNER JOIN Import ON BADGE_C.CARDNO = Import.CARDNOOLD;

-- Import LNAME, relate to the new Card number
UPDATE
    BADGE
SET
    BADGE.LNAME = Import.LNAME
FROM
    BADGE_C
    INNER JOIN BADGE ON BADGE.ID = BADGE_C.ID
    INNER JOIN Import ON BADGE_C.CARDNO = Import.CARDNONEW
    -- Import FNAME, relate to the new Card number
UPDATE
    BADGE
SET
    BADGE.FNAME = Import.FNAME
FROM
    BADGE_C
    INNER JOIN BADGE ON BADGE.ID = BADGE_C.ID
    INNER JOIN Import ON BADGE_C.CARDNO = Import.CARDNONEW
