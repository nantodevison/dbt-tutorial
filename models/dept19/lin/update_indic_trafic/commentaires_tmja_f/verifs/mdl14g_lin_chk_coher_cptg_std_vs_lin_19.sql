{{ config(
    schema='verif',
)}}

{{ mcr_14g_vrf_coher_cptg_std_vs_linear_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_14g_vrf_coher_cptg_std_vs_linear_lin(dept='19') }}
#}
