{{ config(
    schema='verif',
)}}

{{ mcr_4b_vrf_pt_emprise_dept_non_linear_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ mcr_4b_vrf_pt_emprise_dept_non_linear_lin(annee=2024, dept='19') }}
#}