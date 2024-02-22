cls
ocho off
Echo -------------------- Loeschen KFZ privat wenn loeschatribut gesetzt 
Echo .
Echo . Wenn in KFZ privat dieser Haken gesetzt ist wird dieser Datensatz gelöscht
Echo . ist ist das KFZ Kennzeichen noch bei dem Karteninhaber gelistet wird dieses Kennzeichen automatisch erneut angelegt



OSQL -E -d PWNT -n-1 -i "C:\Program Files (x86)\ProWatch\Scripts\KFZ_Priv_Loesch.sql"
REM OK
Echo .

ping localhost 	>>null