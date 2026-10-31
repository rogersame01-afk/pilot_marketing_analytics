select
    subscription_id::varchar                as subscription_id,
    month::date                             as month,
    recognized_revenue_usd::number(18, 2)   as recognized_revenue_usd,
    delivery_cost_usd::number(18, 2)        as delivery_cost_usd,
    support_cost_usd::number(18, 2)         as support_cost_usd
from {{ source('raw', 'customer_monthly') }}