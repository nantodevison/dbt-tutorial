{% macro mcr_14j_vrf_stats_importance_nature_estim_lin(dept=var('dept')) %}

WITH all_combinations AS (
    SELECT DISTINCT importance, nature
    FROM {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}}
    WHERE importance = ANY(ARRAY[{{var('importance_verif')}}])
),
stats AS (
    SELECT 
        importance,
        nature,
        count(*) as cnt,
        round(sum(long_km::numeric),2) as sum_lg_km,
        array_agg(distinct coalesce(numero,'null')) as list_num
    FROM {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} 
    WHERE coment_cpt='estimation'
    GROUP BY importance, nature
)
SELECT 
    ac.importance,
    ac.nature,
    COALESCE(s.cnt, 0) as cnt,
    COALESCE(s.sum_lg_km, 0) as sum_lg_km,
    s.list_num::text[]
FROM all_combinations ac
LEFT JOIN stats s ON ac.importance = s.importance AND ac.nature = s.nature
ORDER BY ac.importance, ac.nature

{% endmacro %}