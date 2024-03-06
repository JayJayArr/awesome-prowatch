--Creation of a trigger to sync all card changes within ProWatch to a separate Table called "CHANGES" and being assigned a elevator Profile

CREATE TRIGGER dbo.TRG_TNA_collector
        ON dbo.EV_LOG
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRAN T1;
    INSERT INTO NUTZTNA(CARDNO, EVNT_DAT, EVNT_TYP)
    --collect all data from the inserted table
	SELECT inserted.CARDNO, 
    inserted.EVNT_DAT, 
    CASE (SELECT count(CARDNO) 
        FROM EV_LOG 
        WHERE CARDNO in (SELECT cardno FROM inserted) 
        AND (EVNT_DESCRP = 'Local Grant' OR EVNT_DESCRP = 'Access Granted')
        AND LOGDEVDESCRP = ''
		AND EVNT_DAT > CAST( GETDATE() AS Date ) )
        % 2
    WHEN 0 THEN 'IN'
    WHEN 1 THEN 'OUT' 
	END
    FROM inserted
    WHERE (EVNT_DESCRP = 'Local Grant'
    OR EVNT_DESCRP = 'Access Granted')
    AND LOGDEVDESCRP = ''
	

	COMMIT TRAN T1;
	
END
GO