select
    month::date               as month,
    channel::varchar          as channel,
    product::varchar          as product,
    spend_usd::number(18, 2)  as spend_usd
from {{ source('raw', 'channel_spend') }}