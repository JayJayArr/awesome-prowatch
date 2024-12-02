/**Script to create new cards in a ProWatch System by creating them 
with bulk badge add and overwriting them 
with data from a csv inserted into a "translation-table"
in this case the translation table is called "Novartis" and contains two Columns: CARDNOOLD & CARDNonEW
*/

use PWNT;
go

update
    BADGE_C
set
    BADGE_C.CARDNO = Novartis.CARDNONEW
from
    BADGE_C
inner join
    Novartis
on 
    BADGE_C.CARDNO = Novartis.CARDNOOLD;

/** 
If the Person ID needs to be updated as well the following script can be used
Replace BADGE_V.BADGE_PERSNO with the correct ProWatch Field to be updated
*/

use PWNT;
go

update
    BADGE_V
set
    BADGE_V.BADGE_PERSNO = Novartis.CARDNONEW
from
    BADGE_C
inner join
    Novartis
on 
    BADGE_C.CARDNO = Novartis.CARDNonEW
inner join
    BADGE_V
on BADGE_V.ID = BADGE_C.ID  ;