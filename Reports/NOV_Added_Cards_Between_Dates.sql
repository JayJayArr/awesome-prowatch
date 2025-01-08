SELECT 
  Year(dbo.Audit_Log.DT) as 'Jahr',
  Month(dbo.Audit_Log.DT) as 'Monat',
  DAY(dbo.Audit_Log.DT) as 'Tag',
  BADGE.LNAME AS 'Last Name',
  BADGE.FNAME AS 'First Name',
  BADGE_V.BADGE_EMPLOYEE_ID AS 'Employee ID'

FROM [PWNT].[dbo].[AUDIT_LOG]
INNER JOIN [PWNT].[dbo].[BADGE_C] ON AUDIT_LOG.KEY1=BADGE_C.ID
INNER JOIN [PWNT].[dbo].[BADGE] ON BADGE.ID=BADGE_C.ID 
INNER JOIN [PWNT].[dbo].[BADGE_V] ON BADGE_V.ID = BADGE.ID 

where OPERATION = 1--Karte hinzugefügt
  and TABLE_NAME = 'BADGE_C'
  and Year(dbo.Audit_Log.DT) >= '2021'
  and (
    WRKST = 'PHCHBS-W31096' --Produktions Büro Stein
  )
Order by Year(dbo.Audit_Log.DT),Month(dbo.Audit_Log.DT), DAY(dbo.Audit_Log.DT)