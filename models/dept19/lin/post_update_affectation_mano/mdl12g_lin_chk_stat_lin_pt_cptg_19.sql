{{ config(
    schema='verif',
)}}

{{ mcr_12g_vrf_stats_linear_pt_cptg_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_12g_vrf_stats_linear_pt_cptg_lin(annee=2024, dept='19') }}
#}