{# 
USE COMPILE BUTTON TO SEE RESULTS, 
PREVIEW WILL NOT WORK WITH THIS EXAMPLE BECAUSE
THE MULTIPLE SELECT STATEMENTS ARE NOT MEANT TO BE RUN
#}



{# Return an integer from a query and store as variable #}
{% set test_query -%}
    select 4 as num4
{% endset -%}



{% set results = run_query(test_query) -%}



{% if execute -%}
    {% set num2 = results[0][0] -%}
{% endif -%}



{# select statement referencing variable will compile successfully #}
select {{num2}} as num2  



{# Can I use a variable as an argument in the range function?  YES #}
{% set test_var = 2 -%}
{% for i in range(1, test_var) -%}
    select 'Test Select'
{% endfor -%}



{# 
'num2' and 'test_var' are not treated the same because of context
Both variables are recognized as numbers... 
#}
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





{# 
...but they can't be referenced in the same way.



FAILS 
num2 variable used as argument in the range function, compile will fail 
TypeError: 'Undefined' object cannot be interpreted as an integer 
#}
{#
{% for i in range(1, num2) %}
    select 'Test Select'
{% endfor %}
#}





{# 
SUCCEEDS
Variable is referenced in an outer 'if' block.
This creates the context that is necessary to reference the variable in the range function.
Select statement will repeat 'num2' times
#}
{% if num2 is number -%}
    {% for i in range(1, num2) -%}
        select 'Test Select'
        {% if loop.index < num2 -%}
        UNION ALL
        {% endif -%}
    {% endfor %}
    
{% endif -%}
