{% macro verifier_nb_cpt_ann_n_lin(dept=var('dept'), annee=var('annee'), suspect=false) %}

select count(*) nb_cpt
from (
    select distinct id_comptag 
    from {{ ref('lin_update_vers_estimation_' ~ dept) }} 
    where id_comptag is not null
) t1
join (
    select id_comptag 
    from {{ source('cptg', 'comptage') }} 
    where annee = '{{ annee }}' {% if suspect %} and suspect = true {% endif %}
) t2 
on t1.id_comptag = t2.id_comptag

{% endmacro %}