
{# Return an integer from a query and store as variable #}
{% set test_query -%}
    select 2 as num2
{% endset -%}

{% set results = run_query(test_query) -%}

{% if execute -%}
    {% set num2 = results[0][0] -%}
{% endif -%}

{# select statement referencing variable will compile successfully #}
select {{num2}} as num2   

{# Can I use a variable as an argument in the range function?  YES #}
{% set test_var = 2 -%}
{% for i in range(1, test_var) -%}
    select 'Test Select'
{% endfor -%}

{# Both variables are recognized as numbers #}
{% if test_var is number -%}
    select 'test_var is a number'
    {% else -%}
    select 'test_var failed number test'
{% endif -%}

{% if num2 is number -%}
    select 'num2 is a number'
    {% else -%}
    select 'num2 failed number test'
{% endif -%}

{# ***************WHY**************** #}
{# num2 variable used as argument, compile will fail #}
{# TypeError: 'Undefined' object cannot be interpreted as an integer #}

{# FAILS #}
{% for i in range(1, num2) %}
    select 'Test Select'
{% endfor %}



