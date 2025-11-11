-- Report Mobile ID Cards with Mail
use PWNT
select LNAME, FNAME, EMAIL_PW, CARDNO, CARDNO
from BADGE inner join BADGE_C on BADGE.ID = BADGE_C.ID
    inner join PARTI_M on PARTI_M.FLDVALUE = BADGE.ID
    inner join PARTI on PARTI.ID = PARTI_M.ID

where PARTI.DESCRP = 'General Capital Group'
    and EMAIL_PW IS NOT null and EMAIL_PW <> ''


