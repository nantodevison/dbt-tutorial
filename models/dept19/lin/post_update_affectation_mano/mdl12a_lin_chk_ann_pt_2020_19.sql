{{ config(
    schema='verif',
)}}

{{ mcr_12a_vrf_ann_pt_2020_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_12a_vrf_ann_pt_2020_lin(dept='19') }}
#}