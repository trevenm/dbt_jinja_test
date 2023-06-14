{{ config(enabled = false) }}

{% set stuff = ['Stuff one', 'Stuff two', 'Stuff three']%}
{% set my_var = 'This variable is' %}

{% for thing in stuff %}
select '{{my_var}} {{thing}}' as test_column
    {% if not loop.last %}
    UNION
    {% endif %}
{% endfor -%}