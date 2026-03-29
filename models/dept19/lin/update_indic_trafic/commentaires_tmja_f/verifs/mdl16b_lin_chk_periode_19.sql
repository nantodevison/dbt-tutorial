{{ 
    config(
        schema='verif'
    )
}}

{{ verifier_periode_lin()}}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl16b_lin_chk_periode_19(dept='19') }}
#}