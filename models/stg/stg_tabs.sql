with seed as (
    select *
    from {{ ref('seed_top_guitar_tabs')}}
)

select * from seed