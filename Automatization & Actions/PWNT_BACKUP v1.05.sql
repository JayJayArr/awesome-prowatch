USE PWNT
GO

IF  EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[PWNT_BACKUP_COUNT]') AND type in (N'U'))
DROP TABLE [dbo].[PWNT_BACKUP_COUNT]
GO

/****** Object:  Table [dbo].[PWNT_BACKUP_COUNT]    Script Date: 04/22/2013 09:03:34 ******/

CREATE TABLE [dbo].[PWNT_BACKUP_COUNT]
(
	[BackupCount] [int] NULL,
	[LastRun] [datetime] NULL
) ON [PRIMARY]

GO

insert into PWNT_BACKUP_COUNT
	(Backupcount,lastrun)
select 0, getdate()-1
/****** Object:  StoredProcedure [dbo].[PWNT_BACKUP]    Script Date: 09/10/2014 10:51:09 ******/
IF  EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[PWNT_BACKUP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PWNT_BACKUP]
GO


/****** Object:  StoredProcedure [dbo].[PWNT_BACKUP]    Script Date: 06/18/2012 14:57:00 ******/


CREATE PROCEDURE [dbo].[PWNT_BACKUP]
	@DBNAME nvarchar(128) ='PWNT'	,
	@PATH   nvarchar(2000)='D:\Pro-Watch Data\Database Backup\',
	@EMAILTO nvarchar(2000)= null,
	@TXMAIL	tinyint =0
as
/* Automatic Database Backup 

	This script will check the day of the week. And will then backup the database to the specified path
	in the specific day of the week backup file. 
	After one week 7 database backup files are in the backup folder DBNAME_x_Weekdayname.bak
	- DBNAME is the name of the database
	- x a sequential number
	- Weekdayname is the name of the week
	
	After one week it will start overwritting the existing database backup.
	
	The script van be used with other databases as well, provide the @DBNAME variable when executing the
	script. Also the backup patch can be defined by the @PATH variable. Please close the path entry with a \
	else an error occurs.
	
	In ProWatch you will find a Procedure and Trigger. The event trigger time can be modified to the time
	when you want the backup to be taken (default 01:30). The ProWatch service must be running in order for 
	the backup to be executed.
	
	24/09/2020  V1.05	Corrected the default date value so the script runs today otherwise it would only work next day. 	
	29/07/2015  v1.04	Fixed install by creating missing tables and default value.
	09/09/2014  v1.03	4.2 Compatible
	07/07/2013  v1.02	Added database size in email subject + body
	18/06/2012  v1.01	Added ProWatch DB Build number in File name.
						Added Email option
	21/07/2011  v1.0	Original Script
*/

SET LANGUAGE us_english
SET DATEFIRST 7
SET DATEFORMAT mdy
DECLARE	@WEEKDAY nvarchar(32),
		@WKD	 INT		 ,
		@LASTRUN datetime,
		@Count	 int,
		@dbver	 nvarchar(8),
		@dbsize  nvarchar(255)

SET @dbver=(select CONVERT(nvarchar(8),build_no)
from db_version)
-- print @dbver		


-- Determine last Run
Select @LASTRUN=lastrun, @Count=BackupCount
from PWNT_BACKUP_COUNT

-- select * from pwnt_backup_count

-- Determine day of the week
SET @WKD=(select DATEPART(weekday,getdate()))
if @WKD=1 BEGIN
	SET @WEEKDAY='1_Sunday'
END
if @WKD=2 BEGIN
	SET @WEEKDAY='2_Monday'
END
if @WKD=3 BEGIN
	SET @WEEKDAY='3_Tuesday'
END
if @WKD=4 BEGIN
	SET @WEEKDAY='4_Wednesday'
END
if @WKD=5 BEGIN
	SET @WEEKDAY='5_Thursday'
END
if @WKD=6 BEGIN
	SET @WEEKDAY='6_Friday'
END
if @WKD=7 BEGIN
	SET @WEEKDAY='7_Saturday'
END
-- Set File Name
DECLARE @BackupFileName varchar(2000);
SET @BackupFileName = @PATH+@DBNAME+'_'+@WEEKDAY+'_DBVersion_'+@DBVER+'.bak'

IF ABS(DATEDIFF(DAY,@LASTRUN,GETDATE()))=0
begin
	print 'today'
	BACKUP DATABASE @DBNAME TO DISK=@BackupFileName WITH DIFFERENTIAL;
	UPDATE PWNT_BACKUP_COUNT set backupcount=backupcount+1,lastrun=GETDATE()
end
else 
BEGIN
	print 'yesterday'
	BACKUP DATABASE @DBNAME TO DISK=@BackupFileName WITH INIT;
	UPDATE PWNT_BACKUP_COUNT set backupcount=0,lastrun=GETDATE()
end

-- Check DB Size
CREATE TABLE #DBINFO
(
	name nvarchar(255),
	db_size nvarchar(255),
	owner nvarchar(255),
	dbid int,
	created datetime,
	status nvarchar(1000),
	compatibility_level nvarchar(250)
)

insert into #DBINFO
exec sp_helpdb

select @dbsize=db_size
from #DBINFO
where name = @dbname

drop table #DBINFO


IF @TXMAIL=1
BEGIN
	-- Email Part

	DECLARE @MyMessage    NVARCHAR(255),
		@UserMessage_R  NVARCHAR(255),
		@iSwitch        int,
		@iRts           INTEGER,
		@szSMTPServerName   varchar(50),
		@szServerFrom   varchar(50),
		@iRealAddr      INTEGER,
		@iChannelType   INTEGER,
		@szByWhom       NVARCHAR(255),
		@email		nvarchar(255),
		@mysubject	nvarchar(255),
	    
    -- TT8480 send mail support for 64bit SQL
    @iMVer          INT,
    @i64Bit         INT,
    @nvMailProc     NVARCHAR(255)


	SET @MySubject='PWNT ('+@DBVER+') Database Backup ('+LTRIM(RTRIM(@dbsize))+') Taken on: '+SUBSTRING(@WEEKDAY,3,10)
	SET @email='pwce@honeywell.com'
	SET @MyMessage='Daily ProWatch database ('+@DBVER+') procedure has been executed. Database size currently is '+LTRIM(rtrim(@dbsize))+'.'

	IF @i64Bit = 0 AND 1 <> @iSwitch%2
  BEGIN
		-- exec @iRts = master..xp_sendmail @recipients = @email, @message = @UserMessage, @subject = @evlog_logdevdescrp
		-- exec @iRts = N'master..xp_sendmail @recipients = ''' + @email + N''', @message = ''' + @UserMessage + N''', @subject = ''' + @evlog_logdevdescrp + N'''')
		SET @nvMailProc = N'master..xp_sendmail'
		exec @iRts = @nvMailProc @recipients = @email, @message = @MyMessage, @subject = @Mysubject
	END
  ELSE IF @i64Bit = 0 AND 1 = @iSwitch%2 AND 9 > @iMVer
  BEGIN
		SELECT @szSMTPServerName= SMTP_SERVER_NAME, @nvMailProc = N'master..xp_smtp_sendmail'
		FROM CTRL_FLAGS

		-- exec @iRts = master..xp_smtp_sendmail @server= @szSMTPServerName, @From=@szServerFrom, @To = @email, @message = @UserMessage, @subject = @evlog_logdevdescrp
		-- exec( N'master..xp_smtp_sendmail @server= ''' + @szSMTPServerName + N''', @From=''' + @szServerFrom + N''', @To = ''' +
		--   @email + N''', @message = ''' + @UserMessage + N''', @subject = ''' + @evlog_logdevdescrp + N'''')
		exec @iRts = @nvMailProc @server= @szSMTPServerName, @From=@szServerFrom, @To = @email, @message = @MyMessage, @subject = @Mysubject
	END
  ELSE -- @i64Bit = 1 OR ( @i64Bit = 0 AND 1 = @iSwitch%2 AND @iMVer >= 9 ) and ELSE
  BEGIN
		-- If SMTP_SERVER_FROM is not specified, the default private profile for the current user will be used.
		-- If the user does not have a default private profile, sp_send_dbmail uses the default public profile
		-- for the msdb databas
		IF LEN( ISNULL( @szServerFrom, '' ) ) <= 0
    BEGIN
			-- Use default public/private profile if @szServerFrom is not specified (empty or NULL).
			SET @szServerFrom = NULL
		END
		-- Note: @body can't be empty. Error is returned if empty.
		-- exec @iRts = msdb..sp_send_dbmail @profile_name=@szServerFrom, @recipients = @email, @subject = @evlog_logdevdescrp, @body = @UserMessage
		-- exec ( N'msdb..sp_send_dbmail @profile_name= ''' + @szServerFrom + N''', @recipients = ''' + @email + N''', @subject = ''' + @evlog_logdevdescrp + N''', @body = ''' + @UserMessage + N'''')
		SET @nvMailProc = N'msdb..sp_send_dbmail'
		exec @iRts = @nvMailProc @profile_name=@szServerFrom, @recipients = @email, @subject = @Mysubject, @body = @MyMessage
	END
END

GO


