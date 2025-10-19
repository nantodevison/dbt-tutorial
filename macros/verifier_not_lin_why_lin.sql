{% macro verifier_not_lin_why_lin(annee=var('annee'), dept=var('dept')) %}

select * 
from {{ source('cptg', 'comptage') }} cpt
where not_lin_why is not null 
and exists (
    select 1 
    from {{ ref('lin_update_vers_estimation_' ~ dept) }} lin
    where lin.id_comptag = cpt.id_comptag 
    and lin.src_cpt = 'otv'
)

{% endmacro %}