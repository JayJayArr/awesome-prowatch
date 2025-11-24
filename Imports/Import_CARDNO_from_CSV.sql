/**Script to create new cards in a ProWatch System by creating them 
with bulk badge add and overwriting them 
with data from a csv inserted into a "translation-table"
in this case the translation table is called "Import" and contains two Columns: CARDNOOLD & CARDNONEW
*/
USE PWNT;

GO
UPDATE
    BADGE_C
SET
    BADGE_C.CARDNO = Import.CARDNONEW
FROM
    BADGE_C
    INNER JOIN Import ON BADGE_C.CARDNO = Import.CARDNOOLD;

/** 
If the Person ID needs to be updated as well the following script can be used
Replace BADGE_V.BADGE_PERSNO with the correct ProWatch Field to be updated
*/
USE PWNT;

GO
UPDATE
    BADGE_V
SET
    BADGE_V.BADGE_PERSNO = Import.CARDNONEW
FROM
    BADGE_C
    INNER JOIN Import ON BADGE_C.CARDNO = Import.CARDNonEW
    INNER JOIN BADGE_V ON BADGE_V.ID = BADGE_C.ID;


/**
Rename the Badge FirstName to the already imported Cardnumber, unrelated to Import
 */
USE PWNT;

GO
UPDATE
    BADGE
SET
    BADGE.FNAME = BADGE_C.CARDNO
FROM
    BADGE_C
    INNER JOIN BADGE ON BADGE.ID = BADGE_C.ID;
