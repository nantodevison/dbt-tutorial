{{ config(
    schema='verif',
)}}

{{ verifier_stats_linearisation_nbpt_lgkm_annee() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"annee": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ verifier_stats_linearisation_nbpt_lgkm_annee(dept='19') }}
#}