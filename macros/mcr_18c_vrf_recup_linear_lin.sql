{% macro mcr_18c_vrf_recup_linear_lin(dept=var('dept')) %}

select count(*) as cnt,recup 
 from {{ref('mdl17a_lin_upd_cmt_tmj_f_sens_dbl_spl_' ~ dept)}}
 where coment_cpt='linearisation' 
 group by recup

{% endmacro %}