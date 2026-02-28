{% macro mcr_verifier_recup_linearisation_lin(dept=var('dept')) %}

select count(*) as cnt,recup 
 from {{ref('mdl_lin_update_coment_tmj_f_sens_dbl_spl_' ~ dept)}}
 where coment_cpt='linearisation' 
 group by recup

{% endmacro %}