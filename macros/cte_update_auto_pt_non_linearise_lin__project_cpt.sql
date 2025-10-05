{% macro cte_update_auto_pt_non_linearise_lin__project_cpt(annee=var('annee'), dept=var('dept')) %}

select t1.id_comptag,t2.coment_cpt,t2.id,t2.id_ign,t2.id_simpli,t2.numero,t2.importance,t2.nature,t2.nom_coll_g,t1.route,
case when substr(split_part(t1.id_comptag,'-',2),1,1) in ('A','N','D')
--RRN ou RD a forcement un numero
and substr(split_part(t1.id_comptag,'-',2),2,2) ~ '^[0-9]+$'
and (substr(t1.id_comptag,1,2) = ANY(ARRAY{{ var('dept_na') + var('dept_limitrophes') }}))
and t2.numero is not null then similarity(t1.route,t2.numero)
when t2.numero is null and t2.nom_coll_g is not null then similarity(upper(t1.route),t2.nom_coll_g)
else null end as sim,
round(st_distance(t1.geom,t2.geom)::numeric,2) as dist
--,t2.imp_sup,t2.imp_sup_src,t2.imp_sup_tgt 
from {{source('cptg', 'compteur')}} t1 join {{ref('lin_verif_pt_non_linearise_' ~ dept)}} t3 using(id_comptag)
                                       join {{ref('lin_update_pt_linearise_devenu_assoc_' ~ dept)}} t2 on st_dwithin(t1.geom,t2.geom,50)
order by t1.id_comptag, dist ASC

{% endmacro %}