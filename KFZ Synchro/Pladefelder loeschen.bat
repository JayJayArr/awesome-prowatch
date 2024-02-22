Echo alle Pladefelder loeschen falls nötig (wird normaler
osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_HEX = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_HEX IS NULL))"
osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_HEX2 = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_HEX2 IS NULL))"
osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_DEZ = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_DEZ IS NULL))"
osql -E -d "pwnt" -Q "Update BADGE_V set BADGE_PLADE_DEZ2 = NULL FROM  BADGE_V WHERE  (NOT (BADGE_PLADE_DEZ2 IS NULL))"
	
	pause