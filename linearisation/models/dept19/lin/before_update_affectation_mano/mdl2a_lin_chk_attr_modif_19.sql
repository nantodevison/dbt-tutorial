{{ config(
    schema='verif'
) }}

{{mcr_2a_vrf_attr_modif_bdt_lin()}}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{mcr_2a_vrf_attr_modif_bdt_lin(annee=2024, dept='19')}}
#}