{{ config(
    schema='verif',
)}}

{% set annee_str = var('annee') | string %} 

{{ verifier_nbpt_lgkm_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{ verifier_nbpt_lgkm_lin(annee=2024, dept='19') }}
#}