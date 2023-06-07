{{ config(
    materialized='table'
    )
}}

{% set key_artist = 'Van Halen'-%}

{% set date_query -%}
    select min(billboard_date) as min_date        
    from {{ref('billboard')}} 
    where artist = '{{key_artist}}'
{% endset -%}

{% set dates = run_query(date_query) -%}

{% if execute -%}
    {% set loop_date = dates[0][0]-%}    
{% endif -%}

with chart_activity as (
    {% set loop_count = 100 -%} 
    {% for loop_iteration in range(1, loop_count + 1) -%}
        {% if loop.index <= loop_count -%}
            select DATEADD(d, 7 * {{loop.index}}, '{{loop_date}}') as period_start
                ,DATEADD(week, 12,DATEADD(d, 7 * {{loop.index}}, '{{loop_date}}')) as period_end
                ,artist
                ,song
                ,min(billboard_rank) as min_song_rank
                ,max(billboard_rank) as max_song_rank
                ,max(billboard_rank) - min(billboard_rank) as chart_movement                  
            from {{ ref('billboard')}} 
            where billboard_date between DATEADD(d, 7 * {{loop.index}}, '{{loop_date}}') and DATEADD(week, 12,DATEADD(d, 7 * {{loop.index}}, '{{loop_date}}'))
            group by artist
                ,song
            {% if loop.index < loop_count %}
            UNION ALL
            {% endif %}
        {% endif -%}
    {% endfor -%}
),

ranked_movers as (
    select period_start
        ,period_end
        ,artist
        ,song
        ,chart_movement
        ,rank() over (partition by period_start order by chart_movement desc) as rnk
    from chart_activity
),

top_mover as (
    select period_start
        ,period_end
        ,artist
        ,song
        ,chart_movement
    from ranked_movers
    where rnk = 1
)

select * 
from top_mover
order by period_start
