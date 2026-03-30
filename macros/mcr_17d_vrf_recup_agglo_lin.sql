{% macro mcr_17d_vrf_recup_agglo_lin(dept=var('dept')) %}

select split_part(id_comptag,'-',1) as gest, recup, count(*) as cnt 
  from {{ ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept) }}
  where split_part(id_comptag,'-',1) = ANY(ARRAY[{{var('agglo_' ~ dept)}}])
  group by gest,recup

{% endmacro %}