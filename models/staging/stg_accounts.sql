select
    account_id::varchar              as account_id,
    created_date::date               as created_date,
    segment::varchar                 as segment,
    employee_count::number(18, 2)    as employee_count,
    region::varchar                  as region,
    product_interest::varchar        as product_interest
from {{ source('raw', 'accounts') }}
