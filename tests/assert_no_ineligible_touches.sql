
-- Return touches outside the eligible 90-day window.

select
    opportunity_id,
    touch_id,
    touch_date,
    opened_date,
    credited_channel

from {{ ref('fct_attribution') }}

where touch_id is not null

    and (
        touch_date > opened_date

        or touch_date <
            dateadd(day, -90, opened_date)
    )
