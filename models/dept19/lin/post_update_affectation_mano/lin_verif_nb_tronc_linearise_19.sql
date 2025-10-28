{{ 
    config(
        schema='verif'
    )
}}

{{ verifier_nb_tronc_linearise_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ verifier_nb_tronc_linearise_lin(dept='19') }}
#}