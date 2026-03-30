{% macro mcr_2f_vrf_nature_bdt_lin(dept=var('dept')) %}

SELECT coment_cpt,nature,round((sum(long_km))::numeric,2) as sum_lg_km, count(*) cnt 
FROM {{ref('mdl1_creer_vue_' ~ dept)}} 
WHERE nature != ALL(ARRAY{{var('nature_verif')}})
GROUP BY coment_cpt, nature
{% endmacro %}

