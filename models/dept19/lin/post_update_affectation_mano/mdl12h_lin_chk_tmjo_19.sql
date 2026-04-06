{{ config(
    schema='verif',
)}}

{{ mcr_12h_vrf_tmjo_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_12h_vrf_tmjo_lin(dept='19') }}
#}