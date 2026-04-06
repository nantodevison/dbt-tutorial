{{config(
    schema='cte',
)}}

{{ cte1_mcr_14g_vrf_coher_cpt_std_lin__cpt_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ cte1_mcr_14g_vrf_coher_cpt_std_lin__cpt_lin(dept='19') }}
#}