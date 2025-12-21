{% macro verifier_coment_tmj_f_values_lin(dept=var('dept')) %}

select distinct coment_tmj_f 
  from {{ref('lin_update_cpt_hors_dept_dans_na_' ~ dept)}} 
  where src_cpt='otv'
  order by coment_tmj_f

{% endmacro %}