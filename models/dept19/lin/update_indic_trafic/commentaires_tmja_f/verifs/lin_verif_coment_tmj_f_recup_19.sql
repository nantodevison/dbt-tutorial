{{ 
    config(
    schema='verif',
    )
}}

{{ verifier_coment_tmj_f_recup() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ lin_verif_coment_tmj_f_recup_19(dept='19') }}
#}