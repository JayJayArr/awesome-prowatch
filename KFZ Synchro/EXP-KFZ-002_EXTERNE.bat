Echo alle PrivatKFZ loeschen sollte 1x pro Monat durchgef. werden
rem osql -E -d "pwnt" -Q "delete BADGE WHERE (LNAME = N'KFZ externe')"



Echo alle nur ausfuehrens "Cardno_externHEX_ToPW.asc" nicht vorhanden
rem if not exist "D:\DatenSynchronisation\KFZ_Kennzeichen\Cardno_externHEX_ToPW.asc" 
call "C:\Program Files (x86)\ProWatch\Scripts\WIM1_E1.exe"

Echo alle PrivatKFZ loeschen sollte 1x pro Monat durchgef. werden
rem osql -E -d "pwnt" -Q "delete BADGE WHERE (LNAME = N'KFZ externe')"


call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-Extern-KFZ-001


echo 'HEX to DEC erzeugen fuer KFZ Plade '
OSQL -E -d pwnt -n-1 -i "C:\Program Files (x86)\ProWatch\Scripts\EXP-KFZ-001_x.sql"


echo 'Cardno DEZ Export  '
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Exp-Extern-KFZ-001


echo 'Karte importiern  '
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-Extern-KFZ-002



