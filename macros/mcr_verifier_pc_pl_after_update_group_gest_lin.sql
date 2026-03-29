{% macro mcr_verifier_pc_pl_after_update_group_gest_lin(dept=var('dept')) %}

select count(distinct id_comptag) as cnt_cpt,split_part(id_comptag,'-',1) as gest 
 from {{ref('mdl20_lin_upd_pl_final_pl_km_' ~ dept)}} 
 where coment_cpt='linearisation' and pc_pl is null 
 group by gest

{% endmacro %}