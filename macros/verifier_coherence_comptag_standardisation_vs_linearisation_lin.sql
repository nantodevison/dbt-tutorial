{% macro verifier_coherence_comptag_standardisation_vs_linearisation_lin(dept=var('dept'), dist=10) %}

select distinct on (t1.id_comptag) t1.id_comptag id_comptag_standardise,t2.id_comptag id_comptag_linearise,
                   st_distance(t1.geom,t2.geom) as dist,t1.geom
--t1.type_poste,t1.sens_cpt,t1.geom
from ({{cte_verif_coherence_cpt_std_lin__cpt_lin(dept)}})  t1
join
(select id_comptag,ann_pt,tmja,obs_supl,geom from {{ref('lin_update_cpt_hors_dept_dans_na_' ~ dept)}} where id_comptag is not null) t2
on st_dwithin(t1.geom,t2.geom,{{ dist }})
where t1.id_comptag<>t2.id_comptag
order by t1.id_comptag,st_distance(t1.geom,t2.geom) asc

{% endmacro %}