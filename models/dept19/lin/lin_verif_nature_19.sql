{{ config(
    schema='verif',
)}}

SELECT coment_cpt,nature,round((sum(long_km))::numeric,2) as sum_lg_km, count(*) cnt 
FROM {{ref('creer_vue_' ~ var('dept'))}} 
WHERE nature NOT IN {{var('nature_verif')}}
GROUP BY coment_cpt, nature