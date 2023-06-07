with billboard_artists as (
    select {{ mighty('artist') }} as artist     
    from {{ ref('billboard')}}
    group by artist
),

tab_artists as (
    select {{ mighty('artist') }} as artist
    from {{ ref('tabs') }}
    group by artist
),

final as (
    select b.artist 
    from billboard_artists b 
    
    UNION

    select t.artist
    from tab_artists t
)

select * from final