select *
from {{ ref('chart_movement')}}
where chart_movement > 99