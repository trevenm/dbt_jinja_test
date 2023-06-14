{{ config(enabled = false) }}

{% set date_query -%}
    select 3 as num
{% endset -%}

{% set results = run_query(date_query) -%}

{% if execute -%}
    {% set num = results[0][0] -%}
{% endif -%}

{% set test_var = num -%}

{# The following line fails with the error:
   TypeError: 'Undefined' object cannot be interpreted as an integer -#}

{# {% set test_var = range(1, num) -%} -#}  

select 'test var = {{test_var}}' as test_column


