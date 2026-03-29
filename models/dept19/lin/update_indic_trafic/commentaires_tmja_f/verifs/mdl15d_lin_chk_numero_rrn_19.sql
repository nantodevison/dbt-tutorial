{{
    config(
        schema='verif'
    )
}}

{{ verifier_numero_rrn_lin()}}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl15d_lin_chk_numero_rrn_19(dept='19') }}
#}