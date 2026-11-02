
-- Ensure channel spend is not multiplied by joins.

with source_spend as (

    select
        coalesce(sum(spend_usd), 0) as total_spend

    from {{ ref('stg_channel_spend') }}

),

mart_spend as (

    select
        coalesce(sum(spend_usd), 0) as total_spend

    from {{ ref('mart_channel_economics') }}

)

select
    s.total_spend as source_spend,
    m.total_spend as mart_spend,
    m.total_spend - s.total_spend as difference

from source_spend s
cross join mart_spend m

where abs(m.total_spend - s.total_spend) > 0.01
