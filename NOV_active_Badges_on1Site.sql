DECLARE 
    @columns NVARCHAR(MAX) = '',
    @sql NVARCHAR(MAX) = '';

SELECT 
    @columns += QUOTENAME(DESCRP) + ','
FROM 
    CLEAR
       WHERE DESCRP LIKE 'HUBU%'
ORDER BY 
    DESCRP;

SET @columns = LEFT(@columns, LEN(@columns) - 1);



SET @sql = '
SELECt * FROM (

SELECT LNAME, FNAME, BADGE_C.CARDNO, DESCRP FROM BADGE 
INNER JOIN BADGE_C ON BADGE.ID = BADGE_C.ID
FULL OUTER JOIN BADGE_CC ON BADGE.ID = BADGE_CC.ID
INNER JOIN CLEAR ON BADGE_CC.CLEAR_COD = CLEAR.ID
WHERE STAT_COD = ''A''
AND DESCRP LIKE ''HUBU%''
) t
PIVOT
(
COUNT(DESCRP)
FOR DESCRP IN ('+ @columns +')
) AS Pivottable';

EXECUTE sp_executesql @sql;