SELECT *
FROM [PWNT].[dbo].[BADGE_C] INNER JOIN [PWNT].[dbo].BADGE_V on [PWNT].[dbo].[BADGE_C].ID = [PWNT].[dbo].[BADGE_V].ID
WHERE 
    [PWNT].[dbo].[BADGE_C].CARDNO like '3737%'
AND
    BADGE_SITE_CODE = 'FRRU'