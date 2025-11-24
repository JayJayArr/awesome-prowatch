SELECT
    lname 'Last Name',
    fname 'First Name'
FROM
    BADGE EXEC sp_MSforeachtable 'DROP TABLE ?' --Dropping all tables(except a few) from the Compliance Report Manager
