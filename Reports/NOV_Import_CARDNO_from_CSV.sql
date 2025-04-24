/**Script to create new cards in a ProWatch System by creating them 
with bulk badge add and overwriting them 
with data from a csv inserted into a "translation-table"
in this case the translation table is called "Novartis" and contains two Columns: CARDNOOLD & CARDNonEW
*/
USE PWNT;

GO
UPDATE
    BADGE_C
SET
    BADGE_C.CARDNO = Novartis.CARDNONEW
FROM
    BADGE_C
    INNER JOIN Novartis ON BADGE_C.CARDNO = Novartis.CARDNOOLD;

/** 
If the Person ID needs to be updated as well the following script can be used
Replace BADGE_V.BADGE_PERSNO with the correct ProWatch Field to be updated
*/
USE PWNT;

GO
UPDATE
    BADGE_V
SET
    BADGE_V.BADGE_PERSNO = Novartis.CARDNONEW
FROM
    BADGE_C
    INNER JOIN Novartis ON BADGE_C.CARDNO = Novartis.CARDNonEW
    INNER JOIN BADGE_V ON BADGE_V.ID = BADGE_C.ID;