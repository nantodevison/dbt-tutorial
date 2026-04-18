{{ config(
    schema='cte'
) }}

{{cte1_mcr_13a_vrf_cpt_mm_sect_homo_lin__cpt_proche(dept=var('dept'))}}
{# 
  Documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19", "distance": 50}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ cte_verif_cpt_mm_section_homo__cpt_proche(dept='19', distance=50) }}
#}