SELECT
    lname 'Last Name',
    fname 'First Name',
    Cardno 'CARDNO',
    FirstSwipe 'First Swipe of Day',
    LastSwipe 'Last Swipe of Day',
    dbo.PWAP_DATE_DIFF (FirstSwipe, LastSwipe) AS 'Duration'
FROM
    (
        SELECT
            lname,
            fname,
            cardno,
            dbo.PWAP_EV_LOG_MIN_DATE(cardno, DateOnly) AS FirstSwipe,
            dbo.PWAP_EV_LOG_MAX_DATE(cardno, DateOnly) AS LastSwipe
        FROM
            (
                SELECT
                    DISTINCT lname,
                    fname,
                    cardno,
                    CAST(FLOOR(CAST(evnt_dat AS float)) AS datetime) AS DateOnly
                FROM
                    dbo.ev_log
                WHERE
                    evnt_Dat >= getdate() -30
                    AND (
                        (
                            CONVERT(VARBINARY(128), EV_LOG.BadgeNo) NOT IN (
                                SELECT
                                    fldvalue
                                FROM
                                    parti_m
                            )
                            OR (
                                NOT EXISTS (
                                    SELECT
                                        id
                                    FROM
                                        uid_t
                                    WHERE
                                        id = 0 x003B42323432303942312D353443412D3439
                                )
                                AND NOT EXISTS (
                                    SELECT
                                        id
                                    FROM
                                        class_t
                                    WHERE
                                        id = 0 x002FF23F11525A0C11D2AA3A0040051FCE21
                                )
                            )
                            OR (
                                (
                                    CONVERT(VARBINARY(128), EV_LOG.BadgeNo) NOT IN (
                                        SELECT
                                            fldvalue
                                        FROM
                                            parti_m
                                        WHERE
                                            id IN (
                                                SELECT
                                                    partid
                                                FROM
                                                    uid_t
                                                WHERE
                                                    id = 0 x003B42323432303942312D353443412D3439
                                                    AND gr_flg = 'R'
                                            )
                                    )
                                )
                                AND (
                                    (
                                        CONVERT(VARBINARY(128), EV_LOG.BadgeNo) IN (
                                            SELECT
                                                fldvalue
                                            FROM
                                                parti_m
                                            WHERE
                                                id IN (
                                                    SELECT
                                                        partid
                                                    FROM
                                                        uid_t
                                                    WHERE
                                                        id = 0 x003B42323432303942312D353443412D3439
                                                        AND gr_flg = 'G'
                                                )
                                        )
                                    )
                                    OR (
                                        CONVERT(VARBINARY(128), EV_LOG.BadgeNo) IN (
                                            SELECT
                                                fldvalue
                                            FROM
                                                parti_m
                                            WHERE
                                                id IN (
                                                    SELECT
                                                        partid
                                                    FROM
                                                        class_t
                                                    WHERE
                                                        id = 0 x002FF23F11525A0C11D2AA3A0040051FCE21
                                                )
                                        )
                                    )
                                )
                            )
                        )
                    )
                    AND evnt_addr = 500
            ) AS Card_Name_Date
    ) AS Card_Name_Date_Time
ORDER BY
    lname,
    fname
