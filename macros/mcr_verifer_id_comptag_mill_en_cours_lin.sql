{% macro mcr_verifer_id_comptag_mill_en_cours_lin(dept=var('dept'), annee=var('annee')) %}

select distinct id_comptag 
  from {{ref('mdl_lin_update_coment_tmj_f_sens_dbl_spl_' ~ dept)}}
  where coment_cpt='linearisation' and ann_pt='{{ annee }}' 
  order by id_comptag

{% endmacro %}