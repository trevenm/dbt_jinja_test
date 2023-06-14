{{ config(severity = 'warn') }}

select *
from {{ ref('dim_artist')}}
where artist = 'Van Halen'