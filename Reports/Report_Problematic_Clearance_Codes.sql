-- Find Clearance Codes which might be Problematic according to the Count per Person 
select *
from (
select lname, fname, count(*) as [Assigned Clearance Codes]
    from badge b
        left outer join badge_cc bcc on b.id=bcc.ID
    group by lname,fname) x
where [Assigned Clearance Codes]>=12
-- Change to 12 or 32 depending on system options setting

-- If this yields results investigate closer with the following:
WITH
    x
    as
    (
        SELECT
            PANEL_ID as Panel,
            CARDNO as Cardnumber,
            SEQ as Sequence,
            C.Descrp as ClearanceCodes, COUNT(SEQ) OVER (PARTITION BY PANEL_ID, CARDNO) AS TotalCCPerCardPerPanel
        FROM DNV_PANEL_CARD_ACCLEV dnv
            inner join clear c on dnv.CLEAR_COD=c.id
    )
SELECT *
FROM x
WHERE TotalCCPerCardPerPanel >12
-- Change to 12 or 32 depending on system options setting
order by Cardnumber,ClearanceCodes

-- To find the Clearance Codes assigned to a specific card found above
select bc.id, bc.cardno, bc.STAT_COD, c.DESCRP, c.ID
from badge_c bc
    inner join badge_cc bcc on bc.id=bcc.id
    inner join clear c on bcc.CLEAR_COD=c.id
where bc.cardno='114734'
--Adjust for the relevant Card
order by c.descrp