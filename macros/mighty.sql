{% macro mighty(artist_name) %}

    case
      when {{artist_name}} = 'Van Halen'
        then 'The Mighty ' || {{artist_name}}
      else {{artist_name}}
    end

{%- endmacro %}