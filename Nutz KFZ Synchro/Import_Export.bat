ECHO off
cls
ECHO -------------------- Ausfuehrung alle 1 STD durch Task-Scheduler Import_Export_ZUKO-------------------------
ECHO .

-- ECHO -------------------- Zum testen der Inputfunktion------------------------
-- if exist D:\DatenSynchronisation\Agenda\Daten_Agenda\Pers_imp_Agendax.csv copy D:\DatenSynchronisation\Agenda\Daten_Agenda\Pers_imp_Agendax.csv D:\DatenSynchronisation\Agenda\Daten_Agenda\Pers_imp_Agenda.csv
-- if exist D:\DatenSynchronisation\Agenda\Daten_Hand\Pers_imp_Hand1.csv     copy D:\DatenSynchronisation\Agenda\Daten_Hand\Pers_imp_Hand1.csv     D:\DatenSynchronisation\Agenda\Daten_Hand\Pers_imp_Hand.csv

echo '-------------------- Firmen-KFZ NR aus freigegebenen Verzeichnis in Importverzeichnis zum '
copy D:\DatenSynchronisation\KFZ_Kennzeichen\Import_KFZ_Firma\Cardno_Firma.asc D:\DatenSynchronisation\KFZ_Kennzeichen\Cardno_Firma.txt >> D:\DatenSynchronisation\KFZ_Kennzeichen\Import_KFZ_Firma\Cardno_Firma.log

ECHO -------------------- Loeschen KFZ privat wenn Loeschatribut gesetzt 
ECHO .
OSQL -E -d PWNT -n-1 -i "C:\Program Files (x86)\ProWatch\Scripts\KFZ_Priv_Loesch.sql"
-- OK
ECHO .

ECHO -------------------- Daten Import aus CSV Tabelle  von DTU Imp-HA-001 
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-HA-001
	-- aus File "D:\DatenSynchronisation\Agenda\Daten_Hand\Pers_imp_Hand.csv" OK

ECHO Ping localhost > NUL 

ECHO .
ECHO -------------------- Daten Import aus Agenda nach Prowatch aus PWBadgeLoad.exe" von DTU Imp-AG-002
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-AG-002
	-- aus File "D:\DatenSynchronisation\Agenda\Daten_Agenda\Pers_imp_Agenda.csv" OK
	
ECHO .
ECHO Ping localhost > NUL


ECHO -------------------- Hinzufuegen der RomCodeUID  zu Prowatch UID15 UND UID08 und sonstige 
ECHO .

OSQL -E -d SALTO_SPACE -n-1 -i "C:\Program Files (x86)\ProWatch\Scripts\Import_Export.SQL"
-- OK
ECHO .

ECHO Ping localhost > NUL 

ECHO P02  
ECHO -------------------- Daten Export zu Salto von DTU E-SA-001 
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" E-SA-001
	
ECHO .
ECHO Ping localhost > NUL

ECHO P01
ECHO -------------------- Daten Export zu Zeiterfassung von DTU E-ZE-001
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" E-ZE-001
ECHO .
ECHO Ping localhost > NUL

ECHO P03
ECHO --------------------  KFZ Privat import
call "C:\Program Files (x86)\ProWatch\Scripts\EXP-KFZ-001_x.bat"
ECHO .
ECHO Ping localhost > NUL

ECHO P02
ECHO --------------------  KFZ Externe (Lieferanten) import
call "C:\Program Files (x86)\ProWatch\Scripts\EXP-KFZ-002_EXTERNE.bat"
ECHO .
ECHO Ping localhost > NUL

echo '-------------------- Karte NR Firmen KFZ exportieren zum Import unten '
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Exp-KFZ-Firma
Ping localhost > NUL 

echo '-------------------- Karte Firmen KFZ importieren  '
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" Imp-KFZ-Firma
ECHO Ping localhost > NUL 

ECHO -------------------- Daten Export zu Tankstelle (TA_Pers_export.csv) von DTU E-TA-001
call "D:\DatenSynchronisation\Tankstelle\BD\StartManuellPers.bat"
ECHO .
ECHO Ping localhost > NUL

ECHO -------------------- Daten Export zu Tankstelle (TA_KFZ_export.csv) von DTU E-TA-002
call "D:\DatenSynchronisation\Tankstelle\BD\StartManuellKFZ.bat"
ECHO .
Ping localhost > NUL

ECHO -------------------- Daten Import f�r Handyoeffnung Tor
call "C:\Program Files (x86)\ProWatch\Scripts\E_1_PHONE.bat"
ECHO .
Ping localhost > NUL

ECHO -------------------- Alte Daten aus AREA Loeschen
call "C:\Program Files (x86)\ProWatch\Scripts\AREA_DEL_OLD.bat" 

ECHO .
ECHO Ping localhost > NUL