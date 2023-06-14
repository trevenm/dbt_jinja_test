with billboard_songs as (
    select song as song_title
        ,min(billboard_date) as first_billboard_appearance
        ,max(billboard_date) as last_billboard_appearance
        ,min(peak_rank) as peak_billboard_rank
    from {{ ref('stg_billboard')}}
    group by song
),

tab_songs as (
    select song_name as song_title
    ,sum(song_hits) as total_tab_views
    ,max(song_rating) as top_song_rating
    from {{ ref('stg_tabs') }}
    group by song_name
),

all_songs as (
    select song_title
    from billboard_songs
    
    UNION

    select song_title
    from tab_songs
),

final as (
    select a.song_title
        ,b.first_billboard_appearance
        ,b.last_billboard_appearance
        ,b.peak_billboard_rank
        ,t.total_tab_views
        ,t.top_song_rating
    from all_songs a 
    left join billboard_songs b on a.song_title = b.song_title
    left join tab_songs t on a.song_title = t.song_title
)

select * from final