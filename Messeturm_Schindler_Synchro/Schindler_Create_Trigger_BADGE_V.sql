--Creation of a trigger to sync all card changes within ProWatch to a separate Table called "CHANGES" and being assigned a elevator Profile

CREATE TRIGGER dbo.TRG_aufzug_changed_V
        ON dbo.BADGE_V
AFTER UPDATE
AS
BEGIN
    IF (UPDATE(ELEVATOR_PROFILE))BEGIN
    SET NOCOUNT ON;
	BEGIN TRAN T1;
    --deleted always refers to the table that was deleted from, of course there is no CARDNO on BADGE_V
    INSERT INTO CHANGES(PERSON_ID,LNAME, FNAME, PROFILENAME, CARDNO, ISSUE_DATE, EXPIRE_DATE)
	SELECT c.CARDNO AS PERSON_ID, b.LNAME, b.FNAME, v.ELEVATOR_PROFILE AS PROFILENAME, c.CARDNO AS CARDNO, c.ISSUE_DATE, c.EXPIRE_DATE
    FROM inserted i 
    INNER JOIN dbo.BADGE b       ON i.ID = b.ID
    INNER JOIN dbo.BADGE_C c     ON i.ID = c.ID
    INNER JOIN BADGE_V v         ON i.ID = v.ID
	
    --ToDo: change Expire Date of all Deleted Cards to 2000-01-01 00:00:00.000
    UPDATE CHANGES
    SET CHANGES.EXPIRE_DATE = '2000-01-02 00:00:00.000', CHANGES.ISSUE_DATE = '2000-01-01 00:00:00.000'
	from inserted i 
    FULL OUTER JOIN BADGE_C c on c.ID  = i.ID
    FULL outer join CHANGES on c.CARDNO = CHANGES.CARDNO
    where c.STAT_COD <> 'A'
		
	COMMIT TRAN T1;
    END;
	
END
GO
