-- Project 1: Marketing Channel Economics
-- Grain: opportunity-open month x product x channel.

with attribution as (
select
  date_trunc('month', opened_date)::date as month,
  product,
  credited_channel as channel,
  -- Aggregate attribution BEFORE joining to spending.
    sum(
            case
                when stage = 'closed_won'
                then linear_weight
                else 0
            end
        ) as credited_wins,

        sum(
            case
                when stage = 'closed_won'
                then arr_usd * linear_weight
                else 0
            end
        ) as attributed_arr_usd
from
{{ ref('fct_attribution') }}
group by 1,2,3)
,

spend as (

    -- Aggregate spending at the same reporting grain.
    select
        month,
        product,
        channel,
        sum(spend_usd) as spend_usd

    from {{ ref('stg_channel_spend') }}

    group by 1, 2, 3

),
combined as (

    -- Retain spend-only and attribution-only records.
    select
        coalesce(s.month, a.month) as month,
        coalesce(s.product, a.product) as product,
        coalesce(s.channel, a.channel) as channel,

        coalesce(s.spend_usd, 0) as spend_usd,
        coalesce(a.credited_wins, 0) as credited_wins,
        coalesce(a.attributed_arr_usd, 0)
            as attributed_arr_usd

    from spend as s

    full outer join attribution as a
        on s.month = a.month
        and s.product = a.product
        and s.channel = a.channel

)

select
    month,
    product,
    channel,

    spend_usd,
    credited_wins,
    attributed_arr_usd,

    -- Acquisition cost per credited customer.
    -- Zero-cost channels remain NULL because their
    -- acquisition costs are not fully captured.
    case
        when spend_usd > 0 and credited_wins > 0
        then spend_usd / credited_wins
        else null
    end as media_cac_usd,

    -- Booked ARR attributed per marketing dollar.
    case
        when spend_usd > 0
        then attributed_arr_usd / spend_usd
        else null
    end as attributed_arr_per_spend

from combined

