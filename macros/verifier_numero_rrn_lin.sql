{% macro verifier_numero_rrn_lin(dept=var('dept')) %}

select distinct numero 
 from {{ ref('lin_update_coment_tmj_f_lui_mm_' ~ dept)}} 
 where cl_admin = ANY(ARRAY{{var('cl_admin_rrn_verif')}})

{% endmacro %}