select lname 'Last Name', fname 'First Name' from BADGE
EXEC sp_MSforeachtable 'DROP TABLE ?'
--Dropping all tables(except a few) from the Compliance Report Manager