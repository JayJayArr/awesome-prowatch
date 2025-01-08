--Creation of a trigger to sync all card changes within ProWatch to a separate Table called "CHANGES" and being assigned a elevator Profile

CREATE TRIGGER dbo.TRG_aufzug_changed
        ON dbo.BADGE_C
AFTER INSERT, UPDATE, Delete
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRAN T1;
    INSERT INTO CHANGES(PERSON_ID,LNAME, FNAME, PROFILENAME, CARDNO, ISSUE_DATE, EXPIRE_DATE)
    --collect all data from the deleted/inserted table
	SELECT d.CARDNO AS PERSON_ID, b.LNAME, b.FNAME, v.ELEVATOR_PROFILE AS PROFILENAME, d.CARDNO AS CARDNO, c.ISSUE_DATE, c.EXPIRE_DATE
    FROM deleted d 
    INNER JOIN dbo.BADGE b       ON d.ID = b.ID
    INNER JOIN dbo.BADGE_C c     ON d.CARDNO = c.CARDNO
    INNER JOIN BADGE_V v         ON d.ID = v.ID
    UNION
	SELECT i.CARDNO AS PERSON_ID, b.LNAME, b.FNAME, v.ELEVATOR_PROFILE AS PROFILENAME, i.CARDNO AS CARDNO, c.ISSUE_DATE, c.EXPIRE_DATE
    FROM inserted i 
    INNER JOIN dbo.BADGE b       ON i.ID = b.ID
    INNER JOIN dbo.BADGE_C c     ON i.CARDNO = c.CARDNO
    INNER JOIN BADGE_V v         ON i.ID = v.ID
	
    --change Issue/Expire Date of all Deleted Cards to 2000-01-01 00:00:00.000
    UPDATE CHANGES
    SET CHANGES.EXPIRE_DATE = '2000-01-02 00:00:00.000', CHANGES.ISSUE_DATE = '2000-01-01 00:00:00.000'
	from deleted d 
    FULL outer join CHANGES on d.CARDNO = CHANGES.CARDNO
	full outer join inserted i on d.ID = i.ID
    full outer join BADGE_C c on c.CARDNO = d.CARDNO
    where (d.ID IS NOT NULL and i.ID IS NULL) OR c.STAT_COD <> 'A'
		
	COMMIT TRAN T1;
	
END
GO
