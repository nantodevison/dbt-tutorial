{{ config(
    schema='verif',
)}}

{{ verifier_stats_linearisation_nbpt_gest() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ verifier_stats_linearisation_nbpt_gest(dept='19') }}
#}