{% macro mcr_23a_vue_lin_finale(dept=var('dept')) %}

select * from {{ref('mdl22_lin_upd_cmt_tmj_f_estim_' ~ var('dept'))}}

{% endmacro %}