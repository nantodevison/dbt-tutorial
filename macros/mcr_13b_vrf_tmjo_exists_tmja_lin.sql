{% macro mcr_13b_vrf_tmjo_exists_tmja_lin(dept=var('dept')) %}

select distinct on (t2.id_comptag) t2.id_comptag,
       t2.annee,
       t3.type_poste,
       t1.id as id_indic_agrege,
       t1.id_comptag_uniq,
       t1.indicateur,
       t1.valeur,
       t1.fichier
from {{ source('cptg', 'indic_agrege') }} t1 
join {{ source('cptg', 'comptage') }} t2 
    on t1.id_comptag_uniq = t2.id
join {{ source('cptg', 'compteur') }} t3 
    on t2.id_comptag = t3.id_comptag
where t1.indicateur = 'tmja' 
and exists (
    select 1 
    from {{ ref('mdl12h_lin_chk_tmjo_' ~ dept) }} tmjo
    where tmjo.id_comptag = t2.id_comptag
)
order by t2.id_comptag, t2.annee::int desc

{% endmacro %}