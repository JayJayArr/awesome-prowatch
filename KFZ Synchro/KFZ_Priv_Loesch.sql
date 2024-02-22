--- Wenn in KFZ privat dieser haken gesetzt ist wird dieser Datensatz gelöscht
--- ist ist das KFZ Kennzeichen noch bei dem Karteninhaber gelistet wird dieses Kennzeichen automatisch erneut angelegt

Delete Badge 
FROM            BADGE AS BADGE_1 INNER JOIN
                         BADGE_V AS BADGE_V_1 ON BADGE_1.ID = BADGE_V_1.ID RIGHT OUTER JOIN
                         BADGE INNER JOIN
                         BADGE_V ON BADGE.ID = BADGE_V.ID ON BADGE_V_1.BADGE_PERSNO = BADGE.FNAME
WHERE        (BADGE_V_1.BADGE_PERSNO IS NOT NULL) AND (NOT (BADGE_1.LNAME LIKE N'KFZ%')) AND (NOT (BADGE.LNAME LIKE N'Vis%')) AND (NOT (BADGE.LNAME LIKE N'TEMP%')) AND 
                         (NOT (BADGE.LNAME LIKE N'Sho%')) AND (BADGE_V_1.BADGE_KFZ_LOESCH = 1)

UPDATE       BADGE_V SET BADGE_KFZ_LOESCH = 0
WHERE        (BADGE_KFZ_LOESCH = 1)