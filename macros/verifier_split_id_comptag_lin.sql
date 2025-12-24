{% macro verifier_split_id_comptag_lin(modele, part=1, separator='-') %}

select distinct split_part(id_comptag, '{{ separator }}', {{ part }}) 
from {{ ref(modele) }} 
where id_comptag is not null

{% endmacro %}
