{{
    config(
    schema='verif',
    )
}}

{{ verifier_coment_tmj_f_attr_modif() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ lin_verif_coment_tmj_f_attr_modif_19(dept='19') }}
#}