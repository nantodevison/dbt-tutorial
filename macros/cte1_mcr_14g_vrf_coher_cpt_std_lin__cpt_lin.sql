{% macro cte1_mcr_14g_vrf_coher_cpt_std_lin__cpt_lin(dept=var('dept')) %}

select t1.id_comptag,t1.type_poste,t1.sens_cpt,t1.geom 
  from {{source('cptg', 'compteur')}} t1
join (select distinct id_comptag from  {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}}  where id_comptag is not null) t2
using (id_comptag)

{% endmacro %}