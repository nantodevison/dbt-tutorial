{% macro mcr_15b_vrf_cmt_tmj_f_attr_modif(dept=var('dept')) %}

select id_ign,id_comptag,nature,numero,importance 
from {{ref('mdl14e_lin_upd_cmt_tmj_f_lui_mm_' ~ dept)}} 
where left(split_part(id_comptag,'-',2),1) in ('A','N') and attr_modif is not null

{% endmacro %}