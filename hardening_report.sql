/**
Script to check the security status of an SQL Server and general parameters in a report
creation: 3.2.25
version: 1.0
**/
use master
go

SELECT CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
WHEN 1 THEN 'Windows Authentication' 
WHEN 0 THEN 'Windows and SQL Server Authentication'
END as [Authentication Mode]  
-- version
SELECT @@Version

-- installed databases
SELECT name as "available Databases" FROM sys.databases
WHERE name NOT IN ('master', 'model', 'tempdb', 'msdb', 'Resource')

-- encryption and how database is secured
SELECT A.name AS 'Database Name'
,    B.name AS 'Cert Name'
,    C.encryptor_type AS 'Type'
,    CASE
                WHEN C.encryption_state = 3 THEN 'Encrypted'
                WHEN C.encryption_state = 2 THEN 'In Progress'
                ELSE 'Not Encrypted'
END AS State
,    C.encryption_state
,    C.percent_complete
,     C.key_algorithm
,     C.key_length
,     C.* FROM sys.dm_database_encryption_keys C
RIGHT JOIN sys.databases A ON A.database_id = C.database_id
LEFT JOIN sys.certificates B ON C.encryptor_thumbprint=B.thumbprint

--encryption in transit
SELECT session_id, encrypt_option, net_transport, protocol_type,  client_net_address, last_read, last_write FROM sys.dm_exec_connections

-- backups encrypted
SELECT 
     A.database_name
,        is_encrypted
,    key_algorithm
,    encryptor_thumbprint
,    encryptor_type
,    type
,    AB.physical_device_name
    FROM msdb.dbo.backupset A
INNER JOIN 
msdb.dbo.backupmediaset C ON A.media_set_id = C.media_set_id
INNER JOIN 
msdb.dbo.backupmediafamily AB on AB.media_set_id=A.media_set_id
ORDER BY A.backup_start_date  DESC

--sql configurations to consider
Select name
,    case
    when value_in_use = 0 then 'DISABLED'
    else 'ENABLED'
    end as State
,    description 
from sys.configurations
where name in ('xp_cmdshell')

-- who has access to the server
SELECT * FROM sys.server_principals
ORDER BY TYPE