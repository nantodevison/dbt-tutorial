{% macro mcr_15d_vrf_numero_rrn_lin(dept=var('dept')) %}

select distinct numero 
 from {{ ref('mdl14e_lin_upd_cmt_tmj_f_lui_mm_' ~ dept)}} 
 where cl_admin = ANY(ARRAY{{var('cl_admin_rrn_verif')}})

{% endmacro %}