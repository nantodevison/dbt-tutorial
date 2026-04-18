{{config(
    schema='cte',
)}}

{{ cte1_mcr_16e_vrf_evo_cpt_dev_assoc__pt_ann_n_asso() }}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ lin_cte_verif_evolution_cptg_devenu_assoc_19__pt_ann_n_asso(dept='19', annee='2024') }}
#}