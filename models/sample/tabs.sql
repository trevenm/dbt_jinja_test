with seed as (
    select *
    from {{ ref('top_guitar_tabs')}}
)

select * from seed