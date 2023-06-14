with billboard_artists as (
    select {{ mighty('artist') }} as artist
        ,min(billboard_date) as first_billboard_appearance
        ,max(billboard_date) as last_billboard_appearance
        ,min(peak_rank) as peak_billboard_rank
    from {{ ref('stg_billboard')}}
    group by artist
),

tab_artists as (
    select {{ mighty('artist') }} as artist
    ,sum(song_hits) as total_tab_views
    ,max(song_rating) as top_song_rating
    from {{ ref('stg_tabs') }}
    group by artist
),

all_artists as (
    select artist
    from billboard_artists
    
    UNION

    select artist
    from tab_artists
),

final as (
    select a.artist
        ,b.first_billboard_appearance
        ,b.last_billboard_appearance
        ,b.peak_billboard_rank
        ,t.total_tab_views
        ,t.top_song_rating
    from all_artists a 
    left join billboard_artists b on a.artist = b.artist
    left join tab_artists t on a.artist = t.artist
)

select * from final