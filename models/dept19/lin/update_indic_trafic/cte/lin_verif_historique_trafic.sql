{{config(
    schema='cte',
)}}

{{ cte_verif_historique_trafic_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"annee": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ cte_verifier_historique_trafic_lin(annee='19') }}
#}