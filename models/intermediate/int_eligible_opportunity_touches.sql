 SELECT
        o.opportunity_id,
        o.account_id,
        o.product,
        o.opened_date,
        o.closed_date,
        o.stage,
        o.arr_usd,

        t.touch_id,
        t.channel,
        t.touch_date

    FROM {{ ref('stg_opportunities') }} AS o

    LEFT JOIN {{ ref('stg_touches') }} AS t
        ON o.account_id = t.account_id
        AND o.product = t.product
        AND t.touch_date BETWEEN
            DATEADD(day, -90, o.opened_date)
            AND o.opened_date