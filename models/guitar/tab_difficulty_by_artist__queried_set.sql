{% set difficulty_set = dbt_utils.get_column_values(table=ref('stg_tabs'), column='difficulty') %}

select
    artist
    {% for diff in difficulty_set %}
    ,sum(case when difficulty = '{{diff}}' then 1 else 0 end) as num_of_{{diff}}
    {% endfor %}
from {{ ref('stg_tabs')}}
group by artist