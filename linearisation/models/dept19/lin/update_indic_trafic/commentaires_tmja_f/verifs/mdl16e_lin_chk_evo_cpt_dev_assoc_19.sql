{{
    config(
        schema='verif'
    )
}}

{{ mcr_16e_vrf_evo_cpt_dev_assoc_lin()}}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ lin_verif_evol_cpt_dev_assoc_19(dept='19', annee='2024') }}
#}