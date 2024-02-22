DECLARE @BackupFileName varchar(100);			 
SET @BackupFileName = 'D:\Datensicherungen\SALTO.db'; 	
BACKUP DATABASE SALTO_SPACE TO DISK=@BackupFileName WITH INIT;	
GO								
