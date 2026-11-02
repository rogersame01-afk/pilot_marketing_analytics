select
    experiment_id::varchar                as experiment_id,
    account_id::varchar                   as account_id,
    assigned_date::date                   as assigned_date,
    arm::varchar                          as arm,
    segment::varchar                      as segment,
    pre_period_engaged::number(18, 2)     as pre_period_engaged
from {{ source('raw', 'experiment_assignments') }}