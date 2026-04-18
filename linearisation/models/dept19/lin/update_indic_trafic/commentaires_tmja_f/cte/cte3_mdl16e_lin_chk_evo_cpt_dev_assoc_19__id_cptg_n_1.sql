{{ config(
    schema='cte'
) }}

{{ cte3_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n_1()}}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ lin_cte_verif_evolution_cptg_devenu_assoc_19__idcptg_n_1(dept='19', annee='2024') }}
#}