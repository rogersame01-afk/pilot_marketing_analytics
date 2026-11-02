select
    experiment_id::varchar                as experiment_id,
    account_id::varchar                   as account_id,
    window_start::date                    as window_start,
    window_end::date                      as window_end,
    converted_60d::number(18, 2)          as converted_60d,
    booked_arr_60d_usd::number(18, 2)     as booked_arr_60d_usd,
    treatment_cost_usd::number(18, 2)     as treatment_cost_usd
from {{ source('raw', 'experiment_outcomes') }}