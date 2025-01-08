--Report to get all Active Cards ready for an initial export to Schindler

SELECT 
c.CARDNO AS PERSON_ID, 
c.CARDNO, 
c.CARDNO, 
NULL,
NULL,
NULL,
v.ELEVATOR_PROFILE AS PROFILENAME, 
FORMAT(CAST(CARDNO AS bigint),'D16') AS CARDNO, 
NULL,
NULL,
convert(varchar, c.ISSUE_DATE, 120) AS ISSUE_DATE,
convert(varchar, c.EXPIRE_DATE, 120) AS EXPIRE_DATE

FROM BADGE_C c
    INNER JOIN BADGE b       ON c.ID = b.ID
    INNER JOIN BADGE_V v     ON c.ID = v.ID

WHERE STAT_COD='A'
