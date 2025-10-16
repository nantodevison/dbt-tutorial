{{ config(
    schema='verif',
)}}

{{ verifier_stats_linearisation_pt_comptage_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ verifier_stats_linearisation_pt_comptage_lin(annee=2024, dept='19') }}
#}