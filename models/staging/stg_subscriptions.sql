select
    subscription_id::varchar  as subscription_id,
    account_id::varchar       as account_id,
    opportunity_id::varchar   as opportunity_id,
    product::varchar          as product,
    start_date::date          as start_date,
    churn_date::date          as churn_date,  -- null for active subscriptions
    mrr_usd::number(18, 2)    as mrr_usd
from {{ source('raw', 'subscriptions') }}