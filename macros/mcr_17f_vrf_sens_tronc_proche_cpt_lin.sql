{% macro mcr_17f_vrf_sens_tronc_proche_cpt_lin(dept=var('dept'), dist_tronc_cpt=50) %}

select s.*
from (
select distinct on (t1.id_comptag) t1.id_comptag,t1.obs_supl,t2.dept,t1.gestionnai,t1.type_poste,t1.sens_cpt,t2.id_ign,t2.sens as sens_ign,
t2.coment_tmj_f,t2.nature,
case when t1.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t2.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t2.coment_tmj_f is null then true
when t1.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t2.sens='{{var("bdtopo_double_sens_verif")}}' and t2.coment_tmj_f='*2' then true
when t1.sens_cpt='{{var("cptg_double_sens_verif")}}' and t2.sens='{{var("bdtopo_double_sens_verif")}}' and t2.coment_tmj_f is null then true
when t1.sens_cpt='{{var("cptg_double_sens_verif")}}' and t2.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t2.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f
from {{source('cptg', 'compteur')}} t1
join {{ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept)}} t2
on t1.id_comptag=t2.id_comptag and st_dwithin(t1.geom,t2.geom,{{dist_tronc_cpt}}) --distance large expres comme join par id_comptag aussi
order by t1.id_comptag, st_distance(t1.geom,t2.geom) asc
) s
where s.verif_coment_tmj_f is false

{%- endmacro %}

