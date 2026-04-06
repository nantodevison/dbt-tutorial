{{config(
    schema="verif"
)}}

{{ mcr_16f_vrf_sens_agglo_lin() }}

{# 
documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl16f_lin_chk_sens_agglo_19(dept='19', annee='2024') }}
#}