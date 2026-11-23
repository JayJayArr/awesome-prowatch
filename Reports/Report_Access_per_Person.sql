SELECT lname AS 'Last Name',
       fname AS 'First Name',
       Badge.ISSUE_DATE AS 'Badge Issue Date',
       Badge.EXPIRE_DATE AS 'Badge Expire Date',
       badge_C.CARDNO AS 'Card Number',
       BADGE_C.ISSUE_DATE AS 'Card Issue Date',
       Badge_C.EXPIRE_DATE AS 'Card Expire Date',
       STAT_COD AS 'Card Status',
       Clear.DESCRP AS 'Clearance Code',
       Timecd.DESCRP AS 'Limiting Timezone'
FROM   BADGE
       FULL OUTER JOIN
       BADGE_C
       ON BADGE.ID = Badge_C.ID
       FULL OUTER JOIN
       BADGE_CC
       ON BADGE.ID = BADGE_CC.ID
       FULL OUTER JOIN
       CLEAR
       ON CLEAR.ID = BADGE_CC.CLEAR_COD
       FULL OUTER JOIN
       TIMECD
       ON CLEAR.DEF_TZ = TIMECD.ID
WHERE  lname IS NOT NULL;