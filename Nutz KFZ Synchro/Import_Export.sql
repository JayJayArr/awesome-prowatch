 Print '******************** Badge Expire_date auf abgelaufen setzen wenn keine aktive Karten '
use PWNT
 /*
SELECT        BADGE.ID, BADGE.LNAME, BADGE.FNAME, BADGE.MI, BADGE.BADGE_STATUS, BADGE.ISSUE_DATE, BADGE.EXPIRE_DATE, BADGE_V.BADGE_EXPIRE_DATE, BADGE_C.CARDNO, BADGE_C.STAT_COD
FROM            BADGE INNER JOIN
                         BADGE_C ON BADGE.ID = BADGE_C.ID LEFT OUTER JOIN
                         BADGE_V ON BADGE.ID = BADGE_V.ID
*/

Update BADGE_V set BADGE_EXPIRE_DATE = '2019-01-01 00:00:00.000'
go
Update BADGE_V set BADGE_EXPIRE_DATE = BADGE.EXPIRE_DATE

FROM            BADGE INNER JOIN
                         BADGE_C ON BADGE.ID = BADGE_C.ID LEFT OUTER JOIN
                         BADGE_V ON BADGE.ID = BADGE_V.ID
WHERE        (BADGE_C.STAT_COD = N'A')



 Print '********************  KFZ löschen wenn löschen gesetzt '
Delete BADGE FROM        BADGE_V INNER JOIN  BADGE ON BADGE_V.ID = BADGE.ID
WHERE         (BADGE.LNAME LIKE N'KFZ%') AND (BADGE_V.BADGE_KFZ_LOESCH = 1)




  --Hinzufügen der RomCodeUID  zu Prowatch UID15 UND UID08

use SALTO_SPACE 
print '******************** BADGE_UID14 und BADGE_UID18 loeschen'
UPDATE       PWNT.dbo.BADGE_V SET BADGE_UID14 = NULL
UPDATE		 PWNT.dbo.BADGE_V SET BADGE_UID08 = NULL


print '******************** BADGE_UID14 aus Salto tb_Cards.ROMCode holen 7BYTE und drehen'
UPDATE       PWNT.dbo.BADGE_V
SET             BADGE_UID14 = (SUBSTRING (tb_Cards.ROMCode,13,2) + SUBSTRING (tb_Cards.ROMCode,11,2) + SUBSTRING (tb_Cards.ROMCode,9,2) 
			     + SUBSTRING (tb_Cards.ROMCode,7,2)  + SUBSTRING (tb_Cards.ROMCode,5,2)  + SUBSTRING (tb_Cards.ROMCode,3,2)
			     + SUBSTRING (tb_Cards.ROMCode,1,2)	)
FROM            PWNT.dbo.BADGE_V INNER JOIN
                         tb_Users ON PWNT.dbo.BADGE_V.BADGE_PERSNO = tb_Users.Dummy1 LEFT OUTER JOIN
                         tb_Cards ON tb_Users.id_user = tb_Cards.id_user


use PWNT 

print '******************** BADGE_UID08 als teil von BADGE_UID14 holen 4BYTE'
UPDATE       PWNT.dbo.BADGE_V
SET             BADGE_UID08 =  SUBSTRING (BADGE_UID14,7,8)
-----------------------------------------------------


print '******************** BADGE_UID_DEC und BADGE_UID_DEC_DES loeschen'
Update BADGE_V	set BADGE_UID_DEC	= NULL
Update BADGE_V	set BADGE_UID_DEC_DES	= NULL


print '******************** Umrechnen von HEX UID08 und UID14  nach UID_DEC'

UPDATE       BADGE_V
	set BADGE_UID_DEC = 
		(CONVERT (bigint, CONVERT(varbinary, (select ('0x'+BADGE_UID08)),1 )))
from BADGE_V
WHERE        (NOT (BADGE_UID08 IS NULL))

UPDATE       BADGE_V
	set BADGE_UID_DEC_DES = 
		(CONVERT (bigint, CONVERT(varbinary, (select ('0x'+BADGE_UID14)),1 )))
from BADGE_V
WHERE        (NOT (BADGE_UID14 IS NULL))


Print '******************** UID erzeugen fuer Salto Romcode automatische medienausgabe'

--Update BADGE_V	set BADGE_UID = ('00000'+BADGE_C.CARDNO) 
--FROM  BADGE_V LEFT OUTER JOIN BADGE_C ON BADGE_V.ID = BADGE_C.ID WHERE (BADGE_C.STAT_COD = N'A')

UPDATE       BADGE_V
SET                BADGE_UID = '00000' + BADGE_C.CARDNO
FROM            BADGE_V LEFT OUTER JOIN
                         BADGE_C ON BADGE_V.ID = BADGE_C.ID
WHERE        (BADGE_C.STAT_COD = N'A') AND (BADGE_C.CARDNO LIKE N'10%')




Print '******************** UID erzeugen fuer KFZ Schlüsselkasten '
--select BADGE_UID_DEC_DES,Badge_SK from BADGE_V

UPDATE       PWNT.dbo.BADGE_V
SET          Badge_SK =  ('0' + (BADGE_UID_DEC_DES))



Print '******************** Partition erzeugen fuer KFZ Plade '
insert into PARTI_M (ID,TABNAME,RESOURCE_TYPE,FLDVALUE)
select 0x001B4D1617865AD84E87A87C2BCE1938B237,'BADGE',41,ID from badge where LNAME='KFZ' 
and ID not in (select FLDVALUE from PARTI_M where ID=0x001B4D1617865AD84E87A87C2BCE1938B237)

insert into PARTI_M (ID,TABNAME,RESOURCE_TYPE,FLDVALUE)
select 0x001B4D1617865AD84E87A87C2BCE1938B237,'BADGE',41,ID from badge where LNAME='KFZ privat' 
and ID not in (select FLDVALUE from PARTI_M where ID=0x001B4D1617865AD84E87A87C2BCE1938B237)

insert into PARTI_M (ID,TABNAME,RESOURCE_TYPE,FLDVALUE)
select 0x001B4D1617865AD84E87A87C2BCE1938B237,'BADGE',41,ID from badge where LNAME='KFZ externe' 
and ID not in (select FLDVALUE from PARTI_M where ID=0x001B4D1617865AD84E87A87C2BCE1938B237)




