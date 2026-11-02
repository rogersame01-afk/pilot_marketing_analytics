
-- Return opportunities with incorrect credit allocation.

select
    opportunity_id,

    sum(first_weight) as first_touch_total,
    sum(last_weight) as last_touch_total,
    sum(linear_weight) as linear_total

from {{ ref('fct_attribution') }}

group by opportunity_id

having
    abs(sum(first_weight) - 1) > 0.000001
    or abs(sum(last_weight) - 1) > 0.000001
    or abs(sum(linear_weight) - 1) > 0.000001
