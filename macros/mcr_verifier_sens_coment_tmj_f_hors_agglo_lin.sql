{% macro mcr_verifier_sens_coment_tmj_f_hors_agglo_lin(dept=var('dept')) %}

select s.*
from (
select t1.id_ign,t1.id_comptag,t1.sens,t2.sens_cpt,t1.coment_tmj_f,
case when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f='*2' then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}' and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f,t1.obs_supl
--t1.obs_tmj1,t1.obs_tmj2,
from {{ref('mdl_lin_update_coment_tmj_f_sens_' ~ dept)}} t1
join {{ source('cptg', 'compteur') }} t2 on t1.id_comptag=t2.id_comptag
where 
(coment_tmj_f is null or coment_tmj_f='/2') --on ne verifie pas les ratio specifique /3,/4,/8
--and split_part(t1.id_comptag,'-',1) not in ('Agglo') --on ne verifie pas les agglo
order by t1.id_comptag,t1.id_ign
) s
where s.verif_coment_tmj_f is false

{%- endmacro %}