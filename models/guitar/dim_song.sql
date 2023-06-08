with billboard_songs as (
    select song as song_title
    from {{ ref('stg_billboard')}}
    group by song
),

tab_songs as (
    select song_name as song_title
    from {{ ref('stg_tabs') }}
    
),

final as (
    select b.song_title
    from billboard_songs b 
    
    UNION

    select t.song_title
    from tab_songs t 
)

select * from final