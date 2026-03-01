{% macro verifier_coment_tmj_f_values_lin(model_src) %}

select distinct coment_tmj_f 
  from {{model_src}} 
  where src_cpt='otv'
  order by coment_tmj_f

{% endmacro %}