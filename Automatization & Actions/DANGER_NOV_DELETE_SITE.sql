/**
Script to delete a whole Site, Event Log, Workspace Event Log, audit Log and Channel_Download_Tracking stay untouched

@Inputs: SearchStr:string - Defines the Basic string defining every item connected with that site.

CAUTION: If EVERY ITEM in that site cannot be found (any query returns no items or less/more than expected) with that string, do not use this script!!!
**/

DECLARE @SearchStr nvarchar(100)
SET @SearchStr = 'ESEM'

DECLARE @SiteID nvarchar(100)
SET @SiteID = (SELECT ID FROM dbo.SITE WHERE DESCRP LIKE '%' + @SearchStr + '%')

SELECT @SiteID

/**
Removing all Clearance Codes from Cards, Deleting Company, Partition, StatusGroups, Site
**/
SELECT * FROM dbo.BADGE_CC WHERE BADGE_CC.CLEAR_COD in (SELECT ID FROM CLEAR where DESCRP LIKE '%' + @SearchStr + '%')
SELECT * FROM dbo.COMPANY WHERE NAM LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.PARTI WHERE DESCRP LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.STATUS_GROUP WHERE DESCRP LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.ROUTE WHERE DESCRP LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.CLEAR WHERE DESCRP LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.OUTPUT WHERE HWDESCRP LIKE '%' + @SearchStr + '%' OR LOCATION LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.INPUT WHERE HWDESCRP LIKE '%' + @SearchStr + '%' OR LOCATION LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.LOGICAL_DEV WHERE DESCRP LIKE '%' + @SearchStr + '%' OR ALT_DESCRP LIKE '%' + @SearchStr + '%' 
SELECT * FROM dbo.READER WHERE HWDESCRP LIKE '%' + @SearchStr + '%' OR LOCATION LIKE '%' + @SearchStr + '%' 
SELECT * FROM dbo.PANEL WHERE DESCRP LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.CHANNEL WHERE DESCRP LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.SITE WHERE ID LIKE '%' + @SearchStr + '%' OR DESCRP LIKE '%' + @SearchStr + '%'
SELECT * FROM dbo.SEARCHRES_R WHERE DESCRP LIKE '%' + @SearchStr + '%'

/**
Removing all Hardware-Remnants Using the Site ID rather than the Description
**/
SELECT * FROM HSDK_CHANGELIST WHERE ID LIKE '%' + @SiteID + '%'
SELECT * FROM SEARCHRES_R WHERE HARDWAREID LIKE '%' + @SiteID + '%'
SELECT * FROM HI_QUEUE WHERE CPAR1 LIKE '%' + @SiteID + '%'
