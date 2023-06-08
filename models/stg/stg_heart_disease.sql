with seed as (
    select age
        ,sex
        ,cp
        ,trestbps
        ,chol
        ,fbs
        ,restecg
        ,thalach
        ,exang
        ,oldpeak
        ,slope
        ,ca
        ,thal
        ,target
    from {{ref('seed_heart_disease')}}
)

select *
from seed