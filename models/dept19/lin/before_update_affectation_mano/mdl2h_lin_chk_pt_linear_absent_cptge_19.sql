{{ config(
    schema='verif',
)}}

{{ mcr_2h_vrf_pt_linear_absent_cptg_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ mcr_2h_vrf_pt_linear_absent_cptg_lin(annee=2024, dept='19') }}
#}