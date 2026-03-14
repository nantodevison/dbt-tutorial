{% macro mcr_vue_lin_finale(dept=var('dept')) %}

select * from {{ref('mdl_lin_update_coment_tmj_f_estim_' ~ var('dept'))}}

{% endmacro %}