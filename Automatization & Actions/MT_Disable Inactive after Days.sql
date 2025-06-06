USE [PWNT]
GO
/****** Object:  StoredProcedure [dbo].[Disable_Inactive]    Script Date: 3/4/2024 9:56:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Disable_Inactive]
AS
BEGIN

DECLARE @CARDSTODISABLE TABLE(cardno nvarchar(32))
INSERT INTO @CARDSTODISABLE 
	SELECT DISTINCT CARDNO FROM BADGE_C
	INNER JOIN BADGE ON BADGE.ID = BADGE_C.ID
	WHERE STAT_COD = 'A'
	AND CARDNO NOT IN (
		SELECT DISTINCT CARDNO FROM EV_LOG
		WHERE EVNT_DAT > (GETDATE() - 28)
		AND CARDNO IS NOT NULL
		AND CARDNO != ''
		AND CARDNO != '0'
	)
	AND CARDNO NOT IN ('101994', '101995', '101996', '101997', '101998', '101999')

DECLARE @count int;
DECLARE @i INT = 0;
SELECT @count=  Count(*) FROM @CARDSTODISABLE

WHILE @i <= @count
BEGIN
	INSERT INTO EV_LOG(RID, LOGDEVDESCRP, EVNT_DESCRP, CARDNO, LNAME, FNAME, EVNT_DAT, EVNT_ADDR)
		VALUES(CAST(NEWID() AS varbinary), 
		'Automatisierung', 
		'Badge Deactivated', 
		(SELECT CARDNO FROM  @CARDSTODISABLE ORDER BY CARDNO OFFSET @i ROWS FETCH NEXT 1 ROWS ONLY), 
		'Automation', 
		'InactiveDisable', 
		GETDATE(), 
		9999
	)
    SET @i = @i + 1;

END

UPDATE PWNT.dbo.BADGE_C 
SET STAT_COD = 'O' 
WHERE CARDNO IN (
	SELECT * FROM @CARDSTODISABLE
)

END