{% macro mcr_verifier_recup_agglo_lin(dept=var('dept')) %}

select split_part(id_comptag,'-',1) as gest, recup, count(*) as cnt 
  from {{ ref('mdl_lin_update_coment_tmj_f_sens_' ~ dept) }}
  where split_part(id_comptag,'-',1) = ANY(ARRAY[{{var('agglo_' ~ dept)}}])
  group by gest,recup

{% endmacro %}