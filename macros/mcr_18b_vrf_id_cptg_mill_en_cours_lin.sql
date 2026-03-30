{% macro mcr_18b_vrf_id_cptg_mill_en_cours_lin(dept=var('dept'), annee=var('annee')) %}

select distinct id_comptag 
  from {{ref('mdl17a_lin_upd_cmt_tmj_f_sens_dbl_spl_' ~ dept)}}
  where coment_cpt='linearisation' and ann_pt='{{ annee }}' 
  order by id_comptag

{% endmacro %}