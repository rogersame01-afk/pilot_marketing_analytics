select
    touch_id::varchar     as touch_id,
    account_id::varchar   as account_id,
    touch_date::date      as touch_date,
    channel::varchar      as channel,
    campaign_id::varchar  as campaign_id,
    product::varchar      as product
from {{ source('raw', 'touches') }}