{% macro mcr_12c_vrf_cptg_not_lin_why_geom_dept_lin(annee=var('annee'), dept=var('dept')) %}

select t1.id_comptag, t1.type_poste,t2.annee, t2.not_lin_why, t3.definition
from (select cpt.id_comptag, cpt.type_poste from {{ source('cptg', 'compteur') }} cpt
      join {{ source('admi', 'dpt_bdt_na_ed' ~ (annee|string)[-2:] ~ '_s') }} aire
        on st_within(cpt.geom, aire.geom) where aire.dept = '{{ dept }}' ) t1
join (select id_comptag, annee, not_lin_why from {{ source('cptg', 'comptage') }} where not_lin_why is not null) t2
    on t1.id_comptag = t2.id_comptag
join {{ source('cptg', 'enum_not_lin_why') }} t3
on t2.not_lin_why = t3.code

{% endmacro %}