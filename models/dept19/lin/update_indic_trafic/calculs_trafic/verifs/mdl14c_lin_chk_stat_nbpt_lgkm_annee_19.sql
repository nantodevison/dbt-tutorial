{{ config(
    schema='verif',
)}}

{{ mcr_14c_vrf_stats_linear_nbpt_lgkm_annee() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ mcr_14c_vrf_stats_linear_nbpt_lgkm_annee(dept='19') }}
#}