{{config(
    schema="verif"
)}}

{{ mcr_verifier_sens_agglo_lin() }}

{# 
documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_verif_sens_agglo_19(dept='19', annee='2024') }}
#}