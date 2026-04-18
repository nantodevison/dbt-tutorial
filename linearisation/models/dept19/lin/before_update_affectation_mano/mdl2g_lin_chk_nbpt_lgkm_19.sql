{{ config(
    schema='verif',
)}}

{% set annee_str = var('annee') | string %} 

{{ mcr_2g_vrf_nbpt_lgkm_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{ mcr_2g_vrf_nbpt_lgkm_lin(annee=2024, dept='19') }}
#}