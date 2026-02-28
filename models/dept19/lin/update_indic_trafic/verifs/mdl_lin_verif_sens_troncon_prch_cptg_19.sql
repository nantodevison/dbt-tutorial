{{
    config(
        schema='verif'
    )
}}

{{ mcr_verifier_sens_tronc_proche_cpt_lin() }}

{#
    documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "dist_tronc_cpt": 50}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_verif_sens_troncon_prch_cptg_19(dept='19', dist_tronc_cpt=50) }}
#}