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
    from {{ref('seed_heart_disease_predict_set')}}
)

select *
from seed