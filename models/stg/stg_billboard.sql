with seed as (
    select DATE as billboard_date
        , RANK as billboard_rank
        , SONG
        , ARTIST
        , LAST_WEEK
        , PEAK_RANK
        , WEEKS_ON_BOARD
    from {{ ref('seed_billboard_top_100_charts')}}
)

select * from seed