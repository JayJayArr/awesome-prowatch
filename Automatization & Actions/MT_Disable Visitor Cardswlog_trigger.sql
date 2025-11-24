USE [PWNT]
GO
    /****** Object:  StoredProcedure [dbo].[Disable_Visitor]    Script Date: 2/29/2024 8:16:42 AM ******/
SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    ALTER PROCEDURE [dbo].[Disable_Visitor] AS
BEGIN
DECLARE
@CARDSTODISABLE TABLE(cardno nvarchar(32), logdevdescrp nvarchar(80))
INSERT INTO
    @CARDSTODISABLE
SELECT
    DISTINCT CARDNO,
    LOGDEVDESCRP
FROM
    PWNT.dbo.EV_LOG
WHERE
    (
        LOGDEVDESCRP = 'U2-08-01 Besucher Anlieferung Ausgang'
        OR LOGDEVDESCRP = '00-01-2 Empfang Besucher OUT'
    )
    AND CARDNO IS NOT NULL
    AND CARDNO <> ''
    AND REC_DAT > dateadd(MINUTE, -5, getdate())
DECLARE
@count int;

DECLARE
@i INT = 0;

SELECT
    @count = Count(*)
FROM
    @CARDSTODISABLE
SELECT
    *
FROM
    @CARDSTODISABLE WHILE @i <= @count
BEGIN
INSERT INTO
    EV_LOG(
        RID,
        LOGDEVDESCRP,
        EVNT_DESCRP,
        CARDNO,
        LNAME,
        FNAME,
        EVNT_DAT,
        EVNT_ADDR
    )
VALUES
    (
        CAST(NEWID() AS varbinary),
        (
            SELECT
                logdevdescrp
            FROM
                @CARDSTODISABLE
            ORDER BY
                CARDNO OFFSET @i ROWS FETCH NEXT 1 ROWS ONLY
        ),
        'Badge Deactivated',
        (
            SELECT
                CARDNO
            FROM
                @CARDSTODISABLE
            ORDER BY
                CARDNO OFFSET @i ROWS FETCH NEXT 1 ROWS ONLY
        ),
        'Automation',
        'VisitorCardDeleted',
        GETDATE(),
        9999
    )
SET
    @i = @i + 1;

END
--Disable Visitor Cards
DELETE FROM
    PWNT.dbo.BADGE_C
WHERE
    CARDNO IN (
        SELECT
            DISTINCT CARDNO
        FROM
            PWNT.dbo.EV_LOG
        WHERE
            (
                LOGDEVDESCRP = 'U2-08-01 Besucher Anlieferung Ausgang'
                OR LOGDEVDESCRP = '00-01-2 Empfang Besucher OUT'
            )
            AND CARDNO IS NOT NULL
            AND CARDNO <> ''
            AND REC_DAT > dateadd(MINUTE, -5, getdate())
    )
END
