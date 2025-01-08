/**
    @file: clean_db_keep_hw.sql
    @author: Jakob Rietdorf
    @version V1.00
    @brief   Script to delete all badges from a ProWatch database while keeping the hardware information

   changelog:
   07.12.2022 JR     Neuerstellung
 
   @date    19/10/2022
**/

USE PWNT

DELETE FROM BADGE

TRUNCATE TABLE EV_LOG --deleting Event log
TRUNCATE TABLE AUDIT_LOG
TRUNCATE TABLE EV_LOG_DISP
TRUNCATE TABLE EV_LOG_RESP
TRUNCATE TABLE EV_LOG_EXT
TRUNCATE TABLE EXT_EVLOG