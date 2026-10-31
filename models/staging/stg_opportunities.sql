select
    OPPORTUNITY_ID::varchar        as opportunity_id,
    account_id::varchar              as account_id,
    product::varchar                 as product,
    opened_date::date               as  opened_date,
    closed_date::date               as  closed_date,
     stage::varchar                 as  stage,
    arr_usd::number(18, 2)    as arr_usd
from {{ source('raw', 'opportunities') }}


