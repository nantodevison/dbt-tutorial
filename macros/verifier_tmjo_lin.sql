{% macro verifier_tmjo_lin(dept=var('dept')) %}

select distinct on (t2.id_comptag) t2.id_comptag,
       t2.annee,
       t3.gestionnai
from {{ source('cptg', 'indic_agrege') }} t1 
join {{ source('cptg', 'comptage') }} t2 
    on t1.id_comptag_uniq = t2.id
join {{ source('cptg', 'compteur') }} t3 
    on t2.id_comptag = t3.id_comptag
join (
    select distinct id_comptag 
    from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }} 
    where src_cpt = 'otv'
) t4 on t3.id_comptag = t4.id_comptag
where t1.indicateur = 'tmjo'
order by t2.id_comptag, t2.annee

{% endmacro %}