{{ config(
    schema='verif',
)}}

{{ mcr_4a_vrf_pt_attr_dept_non_linear_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ mcr_4a_vrf_pt_attr_dept_non_linear_lin( dept='19') }}
#}