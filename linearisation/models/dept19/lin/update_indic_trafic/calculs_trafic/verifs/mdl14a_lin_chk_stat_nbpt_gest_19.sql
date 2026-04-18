{{ config(
    schema='verif',
)}}

{{ mcr_14a_vrf_stats_linear_nbpt_gest() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ mcr_14a_vrf_stats_linear_nbpt_gest(dept='19') }}
#}