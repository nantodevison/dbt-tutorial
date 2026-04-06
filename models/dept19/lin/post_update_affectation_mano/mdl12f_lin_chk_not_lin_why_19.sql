{{ config(
    schema='verif',
)}}

{{ mcr_12f_vrf_not_lin_why_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_12f_vrf_not_lin_why_lin(annee=2024, dept='19') }}
#}