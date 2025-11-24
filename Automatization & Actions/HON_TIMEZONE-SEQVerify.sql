-- This script re-sequences Panel Time Zones, in incremental order, starting at 1.
USE PWNT
GO
DECLARE
@iCOUNTER INT,
@iROW_COUNT INT,
@vcPPID NVARCHAR(64),
@guidTIME_ID VARBINARY(18),
@iSEQ INT,
@iSYSTEM_ZONE INT,
@duplicate int
SET
    @iCOUNTER = 1
SET
    @iROW_COUNT = 1
SET
    @duplicate = 0
DECLARE
TZ_SEQ_CURS CURSOR FOR
SELECT
    PPID,
    TIME_ID,
    SEQ,
    SYSTEM_ZONE
FROM
    PANEL_T
ORDER BY
    PPID,
    SEQ OPEN TZ_SEQ_CURS FETCH NEXT
FROM
    TZ_SEQ_CURS INTO @vcPPID,
    @guidTIME_ID,
    @iSEQ,
    @iSYSTEM_ZONE WHILE @@ FETCH_STATUS = 0
BEGIN
IF (@iCOUNTER = 1)
BEGIN
SET
    @iROW_COUNT = (
        SELECT
            COUNT(*)
        FROM
            PANEL_T
        WHERE
            PPID = @vcPPID
    )
END IF (@iCOUNTER <= @iROW_COUNT)
BEGIN
IF (@iCOUNTER <> @iSEQ)
BEGIN
SET
    @duplicate = @duplicate + 1
END
END
SET
    @iCOUNTER = (@iCOUNTER + 1) IF (@iCOUNTER > @iROW_COUNT)
BEGIN
SET
    @iCOUNTER = 1
END FETCH NEXT
FROM
    TZ_SEQ_CURS INTO @vcPPID,
    @guidTIME_ID,
    @iSEQ,
    @iSYSTEM_ZONE
END DEALLOCATE TZ_SEQ_CURS IF @duplicate > 0 print 'Timezone error!!!  The panel timezones are out of sequence and require updates.'
ELSE print 'The panel timezones are in order. No further action is needed.'
GO
