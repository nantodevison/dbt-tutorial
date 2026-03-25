{{
    config(
        schema = 'verif'
    )
}}

{{ mcr_verifier_recup_linearisation_lin() }}

{#
    documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_verif_recup_linear_19(dept='19') }}
#}