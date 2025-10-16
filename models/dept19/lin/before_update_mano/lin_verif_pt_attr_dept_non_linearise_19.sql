{{ config(
    schema='verif',
)}}

{{ verifier_pt_attr_dept_non_linearise_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ verifier_pt_attr_dept_non_linearise_lin( dept='19') }}
#}