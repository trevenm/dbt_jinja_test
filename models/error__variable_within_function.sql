{{ config(enabled = true) }}

{% set test_query -%}
    select 3 as num
{% endset -%}

{% set results = run_query(test_query) -%}

{% if execute -%}
    {% set num = results[0][0] -%}
{% endif -%}

{# Can't determine how to insert the variable within a set block. 
    The following line fails with the error:
    TypeError: 'Undefined' object cannot be interpreted as an integer -#}

{# {% set test_var = range(1, num) -%} #}


{# But this works fine -#}
{% set test_var = range(1, 3) -%} 


{# And so does this -#}
{# {% set test_var = num -%} #}

select 'test var = {{test_var}}' as test_column


