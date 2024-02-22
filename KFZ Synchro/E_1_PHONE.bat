
Echo -------------------- Daten Anpassung fuer Export Telefon Karten DTU  E_1_PHONE > D:\DatenSynchronisation\PHONE_Tor\Temp\E_1_PHONE_Exp.log
call OSQL -E -d pwnt -n-1 -i "C:\Program Files (x86)\ProWatch\Scripts\E_1_PHONE.sql" >> D:\DatenSynchronisation\PHONE_Tor\Temp\E_1_PHONE_Exp.log
Echo .
ping localhost -4 > NUL


Echo -------------------- Daten Emport in CSV Tabelle  von DTU E_1_PHONE >> D:\DatenSynchronisation\PHONE_Tor\Temp\E_1_PHONE_Imp.log
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" E_1_PHONE >> D:\DatenSynchronisation\PHONE_Tor\Temp\E_1_PHONE_Imp.log
Echo .
ping localhost -4 > NUL


Echo -------------------- Daten Import aus CSV Tabelle  von DTU I_1_PHONE > D:\DatenSynchronisation\PHONE_Tor\Temp\I_1_PHONE_Imp.log
call "C:\Program Files (x86)\ProWatch\DTU\PWBadgeLoad.exe" I_1_PHONE >> D:\DatenSynchronisation\PHONE_Tor\Temp\I_1_PHONE_Imp.log
Echo .
ping localhost -4 > NUL

Echo -------------------- Loeschen Telefonoeffnung wenn Archiv Flag leer  >> D:\DatenSynchronisation\PHONE_Tor\Temp\E_1_PHONE_Exp.log
call OSQL -E -d pwnt -n-1 -i "C:\Program Files (x86)\ProWatch\Scripts\E_1_PHONE_DEL.sql" >> D:\DatenSynchronisation\PHONE_Tor\Temp\E_1_PHONE_Exp.log
Echo .
ping localhost -4 > NUL






