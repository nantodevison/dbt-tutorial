SELECT coment_cpt,nature,round((sum(long_km))::numeric,2) as sum_lg_km, count(*) cnt 
FROM {{ref('lin_creer_vue_dept19')}} 
WHERE nature NOT IN ('Bretelle','Rond-point','Route à 1 chaussée','Route à 2 chaussées','Type autoroutier')
GROUP BY coment_cpt, nature