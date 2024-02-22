Print 'Prozess P03 DEC aus HEX erzeugen fuer KFZ Plade '

Print '******************** DEC aus HEX erzeugen fuer KFZ Plade Priv1 Priv2 '
UPDATE       BADGE_V
	set BADGE_PLADE_DEZ = 
		(CONVERT (bigint, CONVERT(varbinary, (select ('0x'+BADGE_PLADE_HEX)),1 )))
from BADGE_V
WHERE        (NOT (BADGE_PLADE_HEX IS NULL))

UPDATE       BADGE_V
	set BADGE_PLADE_DEZ2 = 
		(CONVERT (bigint, CONVERT(varbinary, (select ('0x'+BADGE_PLADE_HEX2)),1 )))
from BADGE_V
WHERE        (NOT (BADGE_PLADE_HEX2 IS NULL))





