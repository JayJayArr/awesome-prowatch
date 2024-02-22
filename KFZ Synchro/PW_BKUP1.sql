DECLARE @BackupFileName varchar(100);			 
SET @BackupFileName = 'D:\Datensicherungen\PW.db'; 	
BACKUP DATABASE PWNT TO DISK=@BackupFileName WITH INIT;	
GO								
