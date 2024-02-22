

-- alte Einträge in Area löschen AREA_DEL_OLD
--SET LANGUAGE german
--select * from AREA_OCCUPANT where (AREA_OCCUPANT.Event_Time ) < (convert  (varchar, SYSDATETIME (), 104)) 



 SET LANGUAGE german
 delete AREA_OCCUPANT  where   (AREA_OCCUPANT.Event_Time ) < (convert  (varchar, SYSDATETIME (), 104)) 