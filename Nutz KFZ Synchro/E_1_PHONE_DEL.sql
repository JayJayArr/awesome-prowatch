

delete BADGE
FROM            BADGE INNER JOIN
                         BADGE_V ON BADGE.ID = BADGE_V.ID
WHERE        (BADGE_V.BADGE_PERSNO LIKE N'PH%') and (BADGE_V.BADGE_HOMEPH_M IS NULL)

-- Tabelle MobilPhone8 löschen
update   BADGE_V set BADGE_HOMEPHONE8 = NULL
FROM            BADGE_V 

-- Tabelle PernoPhone löschen
update   BADGE_V set BADGE_HOMEPH_P = NULL
FROM            BADGE_V