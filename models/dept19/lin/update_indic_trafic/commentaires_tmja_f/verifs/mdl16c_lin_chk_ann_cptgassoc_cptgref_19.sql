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
    {{ mdl16c_lin_chk_ann_cptgassoc_cptgref_19(dept='19') }}
#}