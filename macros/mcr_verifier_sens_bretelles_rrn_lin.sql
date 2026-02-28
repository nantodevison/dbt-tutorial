{% macro mcr_verifier_sens_bretelles_rrn_lin(dept=var('dept')) %}

select s.id_ign, s.id_comptag, s.sens, s.sens_cpt, s.coment_tmj_f, s.verif_coment_tmj_f, s.obs_supl
from (
select t1.id_ign,t1.id_comptag,t1.sens,t2.sens_cpt,t1.coment_tmj_f,
case when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f='*2' then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}'  and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f,t1.obs_supl
--t1.obs_tmj1,t1.obs_tmj2,
from {{ref('lin_update_coment_tmj_f_ids_' ~ dept)}} t1
join {{source('cptg', 'compteur')}} t2 using(id_comptag)
where t1.id_comptag ~ '((E|n)tree|(S|s)ortie)'
order by t1.id_comptag,t1.id_ign
) s
where s.verif_coment_tmj_f is false

{% endmacro %}