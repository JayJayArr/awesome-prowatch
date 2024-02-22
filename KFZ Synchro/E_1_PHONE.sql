

--------- Leeren der Merkertabelle vor Import--------------------------------------------------
update   BADGE_V set BADGE_HOMEPH_M  = NULL
FROM            BADGE_V
--WHERE        (NOT (BADGE_HOMEPHONE IS NULL))


-------- Anpassen der Telefonummer auf 8 Stellen und in neue Tabelle speichern-----------------
update   BADGE_V set BADGE_HOMEPHONE8 = RIGHT(BADGE_HOMEPHONE, 8)
FROM            BADGE_V
WHERE        (NOT (BADGE_HOMEPHONE IS NULL))

-- zusammensetzen PersnoTyp und Persno für Persno Phone (PH) und in neue Tabelle speichern-----
update   BADGE_V set BADGE_HOMEPH_P = ('PH' +(BADGE_PERSNO))
FROM            BADGE_V
WHERE        (NOT (BADGE_HOMEPHONE IS NULL))


---- zusammensetzen Nach/Vormame und in neue Tabelle speichern BADGE_NAME  --------------------
update   BADGE_V set BADGE_NAME = (Badge.LNAME +' ' + Badge.FNAME)
FROM            BADGE_V INNER JOIN
                         BADGE ON BADGE_V.ID = BADGE.ID
WHERE        (NOT (BADGE_HOMEPHONE IS NULL))









