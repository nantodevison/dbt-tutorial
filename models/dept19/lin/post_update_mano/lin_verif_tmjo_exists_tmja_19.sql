{{ config(
    schema='verif',
)}}

{{ verifier_tmjo_exists_tmja_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ verifier_tmjo_exists_tmja(dept='19') }}
#}