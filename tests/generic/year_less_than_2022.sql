{% test year_less_than_2022(model, column_name) %}

with validation as (
    select YEAR({{ column_name }}) as year_field
    from {{ model }}
),

validation_errors as (
    select year_field
    from validation
    where year_field >= 2022
)

select * from validation_errors

{% endtest %}