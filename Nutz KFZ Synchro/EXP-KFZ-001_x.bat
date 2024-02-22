Echo alle Pladefelder loeschen falls noetig (wird normaler
	rem osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_HEX = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_HEX IS NULL))"
	rem osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_HEX2 = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_HEX2 IS NULL))"
	rem osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_DEZ = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_DEZ IS NULL))"
	rem osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_DEZ2 = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_DEZ2 IS NULL))"

Echo alle PrivatKFZ loeschen sollte 1x pro Monat durchgef. werden
rem osql -E -d "pwnt" -Q "delete BADGE WHERE (LNAME = N'KFZ privat')"

Echo -------------------------------------------------------------------------------
echo Import von Plade und HEX Nr in PW fuer Firmen KFZ aus   Import_PW_PrivKFZ.txt -> WIM1_F1 ->Cardno_FirmaHEX_ToPW.asc
"C:\Program Files (x86)\ProWatch\Scripts\WIM1_F1.exe"

Echo KFZ Plade aus Datei Importieren (Cardno_FirmaHEX_ToPW.asc)
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-KFZ-HEX-F1 

Echo ---------------------------------------------------------------------------------


Echo Aufruf DTU Exp-KFZ-001_1 Exp-KFZ-001_2 und Converter WIM2 loeschen temp File Exp-KFZ-001_1.txt /Exp-KFZ-001_1.txt

Echo KFZ Plade aus PW in Datei Exportieren
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Exp-KFZ-001_1
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Exp-KFZ-001_2


Echo Converter fuer Plade to Hex ausfuehren
"C:\Program Files (x86)\ProWatch\Scripts\WIM2_1.exe"
"C:\Program Files (x86)\ProWatch\Scripts\WIM2_2.exe"

echo Dateien fuer WIM2 Import loeschen
del "D:\DatenSynchronisation\KFZ_Kennzeichen\Exp-KFZ-001_1.txt"
del "D:\DatenSynchronisation\KFZ_Kennzeichen\Exp-KFZ-001_2.txt"

echo Import von Plade und HEX Nr in PW
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-KFZ-HEX-P1
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-KFZ-HEX-P2

echo 'HEX to DEC erzeugen fuer KFZ Plade '
OSQL -E -d pwnt -n-1 -i "C:\Program Files (x86)\ProWatch\Scripts\EXP-KFZ-001_x.sql"

Echo Export Plade Cardno LName FName
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Exp-KFZ-P1
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Exp-KFZ-P2

Echo Import_PW_PrivKFZ1.txt + Import_PW_PrivKFZ1.txt verbinden zu Import_PW_PrivKFZ.txt
Copy D:\DatenSynchronisation\KFZ_Kennzeichen\Import_PW_PrivKFZ1.txt + D:\DatenSynchronisation\KFZ_Kennzeichen\Import_PW_PrivKFZ2.txt D:\DatenSynchronisation\KFZ_Kennzeichen\Import_PW_PrivKFZ.txt

Echo Import_PW_PrivKFZ1.txt + Import_PW_PrivKFZ1.txt loechen
del D:\DatenSynchronisation\KFZ_Kennzeichen\Import_PW_PrivKFZ1.txt
del D:\DatenSynchronisation\KFZ_Kennzeichen\Import_PW_PrivKFZ2.txt

Echo Import und update neue Datensaetze fuer KFZ Privat
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-KFZ-Privat


Echo Update neue Datensaetze fuer KFZ Privat Partition (KFZ) setzen 
osql -E -d "pwnt" -Q "insert into PARTI_M (ID,TABNAME,RESOURCE_TYPE,FLDVALUE)select 0x001B4D1617865AD84E87A87C2BCE1938B237,'BADGE',41,ID from badge where LNAME='KFZ privat' and ID not in (select FLDVALUE from PARTI_M where ID=0x001B4D1617865AD84E87A87C2BCE1938B237)"



Echo .
ECHO Ping localhost > NUL


