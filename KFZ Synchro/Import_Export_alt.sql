  --Hinzufügen der RomCodeUID  zu Prowatch UID15 UND UID08

use SALTO_SPACE 
print '******************** BADGE_UID14 und BADGE_UID18 loeschen'
UPDATE       PWNT.dbo.BADGE_V SET BADGE_UID14 = NULL
UPDATE		 PWNT.dbo.BADGE_V SET BADGE_UID08 = NULL

print '******************** BADGE_UID14 aus Salto tb_Cards.ROMCode holen'
UPDATE       PWNT.dbo.BADGE_V
SET             BADGE_UID14 = tb_Cards.ROMCode
FROM            PWNT.dbo.BADGE_V INNER JOIN
                         tb_Users ON PWNT.dbo.BADGE_V.BADGE_PERSNO = tb_Users.Dummy1 LEFT OUTER JOIN
                         tb_Cards ON tb_Users.id_user = tb_Cards.id_user

print '******************** BADGE_UID08 als teil von BADGE_UID14 holen'
UPDATE       PWNT.dbo.BADGE_V
SET                BADGE_UID08 =  (SELECT LEFT(BADGE_UID14, 8) AS Expr1)

-----------------------------------------------------

use PWNT 

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

Update BADGE_V	set BADGE_UID = ('00000'+BADGE_C.CARDNO) 
FROM  BADGE_V LEFT OUTER JOIN BADGE_C ON BADGE_V.ID = BADGE_C.ID WHERE (BADGE_C.STAT_COD = N'A')