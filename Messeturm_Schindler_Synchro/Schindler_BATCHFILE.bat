REM batchfile which is executed every minute to copy changes from the added SQL-table "CHANGES" into a file to sync with Schindler Port Technology, Table-Deletion is included
bcp "select PERSON_ID,CARDNO,CARDNO,COMPANY,ENTERPRISE,DEPARTMENT,PROFILENAME,FORMAT(CAST(CARDNO AS bigint),'D16'),CARDNO2,CARDNO3,convert(varchar, ISSUE_DATE, 120),convert(varchar, EXPIRE_DATE, 120) FROM [PWNT].[dbo].[CHANGES]" queryout "c:\Schindler\test.txt" -t"|" -r"|\n" -T -c -dPWNT
sqlcmd -s localhost\PWNT -Q "DELETE FROM PWNT.dbo.CHANGES"
TIMEOUT 30
bcp "select PERSON_ID,CARDNO,CARDNO,COMPANY,ENTERPRISE,DEPARTMENT,PROFILENAME,FORMAT(CAST(CARDNO AS bigint),'D16'),CARDNO2,CARDNO3,convert(varchar, ISSUE_DATE, 120),convert(varchar, EXPIRE_DATE, 120) FROM [PWNT].[dbo].[CHANGES]" queryout "c:\Schindler\test.txt" -t"|" -r"|\n" -T -c -dPWNT
sqlcmd -s localhost\PWNT -Q "DELETE FROM PWNT.dbo.CHANGES"
