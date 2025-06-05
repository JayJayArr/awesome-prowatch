-- Report all employees on a specific site for one specific date
SELECT
    DISTINCT CONVERT(char, EVNT_DAT, 112) AS 'Logical Device Site',
    BADGE_V.BROKER_SITE_CODE_EXT AS 'GD db Site Code',
    BADGE_V.BADGE_EMPLOYEE_ID AS 'Employee ID',
    EV_LOG.CARDNO AS 'Cardnumber',
    FNAME AS 'First Name',
    LNAME AS 'Last Name',
    Cast(EVNT_DAT AS date) AS 'Date'
FROM
    EV_LOG
    INNER JOIN BADGE_V ON BADGE_V.id = EV_LOG.BADGENO -- Runtime Filters in ProWatch: convert(char, EVNT_DAT, 112), convert(char, EVNT_DAT, 112)
