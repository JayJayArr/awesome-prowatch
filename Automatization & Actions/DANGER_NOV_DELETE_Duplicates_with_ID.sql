WITH cte AS (
    SELECT 
        ID, 
        SATZA,
        TERID, 
        LDate,
	LTIME,
	ERDAT,
	ERTIM,
	ZAUSW,
	PERNR,
	ABWGR,
	OTYPE,
	PLANS,
	PDC_USRUP,
	Exported 
        ROW_NUMBER() OVER (
            PARTITION BY 
                        SATZA,
        		TERID, 
        		LDate,
			LTIME,
			ERDAT,
			ERTIM,
			ZAUSW,
			PERNR,
			ABWGR,
			OTYPE,
			PLANS,
			PDC_USRUP,
			Exported
            ORDER BY 
                	SATZA,
        		TERID, 
        		LDate,
			LTIME,
			ERDAT,
			ERTIM,
			ZAUSW,
			PERNR,
			ABWGR,
			OTYPE,
			PLANS,
			PDC_USRUP,
			Exported
        ) row_num
     FROM 
        EV_LOG_FOR_EXPORT
)
SELECT * FROM cte
WHERE row_num > 1;