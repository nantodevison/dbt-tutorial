{{ config(
    schema='verif',
)}}

{{ verifier_coherence_comptag_standardisation_vs_linearisation_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ verifier_coherence_comptag_standardisation_vs_linearisation_lin(dept='19') }}
#}
