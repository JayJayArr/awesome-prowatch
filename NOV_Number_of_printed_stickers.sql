SELECT 
  Year(dbo.Audit_Log.DT) as 'Jahr',
  Month(dbo.Audit_Log.DT) as 'Monat', 
  COUNT(OPERATION) as 'Sticker_gedruckt'
FROM [PWNT].[dbo].[AUDIT_LOG]
where OPERATION = 8 --cards really printed
and Year(dbo.Audit_Log.DT) >= '2020'
Group by Year(dbo.Audit_Log.DT),Month(dbo.Audit_Log.DT)
Order by Year(dbo.Audit_Log.DT),Month(dbo.Audit_Log.DT)
