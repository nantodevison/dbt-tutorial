{% macro mcr_2g_vrf_nbpt_lgkm_lin(dept=var('dept')) %}

    select count(distinct id_comptag) as nb_pt,
           round(sum(long_km)::numeric) as sum_lg_km
    from {{ref('mdl1_creer_vue_' ~ dept)}}
    where id_comptag is not null
{% endmacro %}
