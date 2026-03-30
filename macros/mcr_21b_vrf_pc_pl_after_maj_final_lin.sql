{% macro mcr_21b_vrf_pc_pl_after_maj_final_lin(dept=var('dept')) %}

select count(*) as count, 
       count(distinct id_comptag) as count_distinct_id_comptag, 
       array_agg(distinct id_comptag) as list_id_comptag,
       array_agg(distinct split_part(id_comptag,'-',1)) as list_split1_id_comptag
    from {{ref('mdl20_lin_upd_pl_final_pl_km_' ~ dept)}}
    where coment_cpt='linearisation' and pc_pl is null

{% endmacro %}