{{
    config(
        schema='verif'
    )
}}

{{ verifier_stat_importance_nature_estim_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ lin_verif_stat_importc_nature_19(dept='19') }}
#}