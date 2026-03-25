{{
    config(
        schema='verif'
    )
}}

{{ mcr_verifier_ann_cptgassoc_cptgref_lin() }}

{#  
documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_verif_ann_cptgassoc_cptgref_19(dept='19') }}
#}