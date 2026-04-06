{{ config(
    schema='verif',
)}}

{{ mcr_14b_vrf_stats_linear_gests_annees() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ mcr_14b_vrf_stats_linear_gests_annees(dept='19') }}
#}