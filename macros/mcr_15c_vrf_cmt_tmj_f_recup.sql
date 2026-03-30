{% macro mcr_15c_vrf_cmt_tmj_f_recup(dept=var('dept')) %}

select id_ign,id_comptag,coalesce(numero,'NULL') as numero,
       nature,importance,sens,coment_tmj_f,recup 
from  {{ref('mdl14e_lin_upd_cmt_tmj_f_lui_mm_' ~ dept)}}
where left(split_part(id_comptag,'-',2),1) in ('A','N') 
    and recup not in ('pk_ign','ad')

{% endmacro %}