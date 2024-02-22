SELECT 
  Year(dbo.Audit_Log.DT) as 'Jahr',
  Month(dbo.Audit_Log.DT) as 'Monat', 
  COUNT(OPERATION) as 'Karten_hinzugefügt'
FROM [PWNT].[dbo].[AUDIT_LOG]
where OPERATION = 1--Karte hinzugefügt
  and TABLE_NAME = 'BADGE_C'
  and Year(dbo.Audit_Log.DT) >= '2020'
  and (
    WRKST = 'PHCHBS-W31096' --Produktions Büro Stein
  )
Group by Year(dbo.Audit_Log.DT),Month(dbo.Audit_Log.DT)
Order by Year(dbo.Audit_Log.DT),Month(dbo.Audit_Log.DT)