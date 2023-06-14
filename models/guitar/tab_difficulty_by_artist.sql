{% set difficulty_set = ['novice','advanced','intermediate']%}

select
    artist
    {% for diff in difficulty_set %}
    ,sum(case when difficulty = '{{diff}}' then 1 else 0 end) as num_of_{{diff}}
    {% endfor %}
from {{ ref('stg_tabs')}}
group by artist