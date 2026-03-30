{% macro mcr_xx_vrf_cmt_tmj_f_val_lin(model_src) %}

select distinct coment_tmj_f 
  from {{model_src}} 
  where src_cpt='otv'
  order by coment_tmj_f

{% endmacro %}