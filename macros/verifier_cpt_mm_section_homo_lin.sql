{% macro verifier_cpt_mm_section_homo_lin(dept=var('dept')) %}

SELECT id_ign,id_simpli,id_comptag 
  FROM {{ref('lin_cte_verif_cpt_mm_section_homo_' ~ dept ~ '__lineaire_tot')}} 
WHERE id_simpli IN 
    (SELECT id_simpli FROM {{ref('lin_cte_verif_cpt_mm_section_homo_' ~ dept ~ '__lineaire_tot')}} 
where dept='{{dept}}' and id_cpt_proch is true 
GROUP BY id_simpli HAVING COUNT(*) > 1)  and dept='{{dept}}' and id_cpt_proch is true
order by id_simpli asc

{% endmacro %}