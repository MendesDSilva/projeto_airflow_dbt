{% test valid_email(model, column_name) %}

with validation as (
    select {{ column_name }} as email
    from {{ model }}
    where {{ column_name }} not like '%_@__%.__%'
)

select count(*)
from validation

{% endtest %}