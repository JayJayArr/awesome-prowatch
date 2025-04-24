--Report selecting all Boards, their status, their according Panel and both Firmware Versions
SELECT
    DESCRP AS 'Panel Name',
    PANEL.INSTALLED AS 'Panel installed',
    Panel.FIRMWARE_VERSION AS 'Panel Firmware Version',
    SPANEL.HWDESCRP AS 'Subpanel Name',
    SPANEL.INSTALLED AS 'Subpanel installed',
    SPANEL.FIRMWARE_VERSION AS 'Subpanel Firmware'
FROM
    PANEL
    INNER JOIN SPANEL ON PANEL.ID = SPANEL.PPID