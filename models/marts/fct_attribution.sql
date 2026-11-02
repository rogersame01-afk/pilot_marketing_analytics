-- STEP 1: Identify eligible marketing touches
-- Grain: opportunity x eligible marketing touch
-- Only include touches within 90 days before the opportunity opened.

WITH eligible AS (

   select * from {{ ref('int_eligible_opportunity_touches') }}
),

ranked AS (

    SELECT
        *,

        -- Number of eligible touches per opportunity
        COUNT(touch_id) OVER (
            PARTITION BY opportunity_id
        ) AS n_touches,

        -- Earliest marketing interaction
        ROW_NUMBER() OVER (
            PARTITION BY opportunity_id
            ORDER BY touch_date ASC, touch_id ASC
        ) AS first_rank,

        -- Latest marketing interaction
        ROW_NUMBER() OVER (
            PARTITION BY opportunity_id
            ORDER BY touch_date DESC, touch_id DESC
        ) AS last_rank

    FROM eligible
)
SELECT
    *,

    -- Assign unattributed for missing marketing touches
    COALESCE(channel, 'unattributed') AS credited_channel,

    -- First-touch: earliest touch receives 100% credit
    CASE
        WHEN first_rank = 1 THEN 1.0
        ELSE 0.0
    END AS first_weight,

    -- Last-touch: latest touch receives 100% credit
    CASE
        WHEN last_rank = 1 THEN 1.0
        ELSE 0.0
    END AS last_weight,

    -- Linear: distribute credit equally across touches
    -- An opportunity without touches remains unattributed
   case
    when n_touches = 0
        then 1::number(20,12)
    else
        1::number(20,12) / n_touches
end as linear_weight

FROM ranked