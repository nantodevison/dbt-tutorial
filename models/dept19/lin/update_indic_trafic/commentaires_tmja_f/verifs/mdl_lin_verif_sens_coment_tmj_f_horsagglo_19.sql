{{
    config(
        schema='verif'
    )
}}

{{ mcr_verifier_sens_coment_tmj_f_hors_agglo_lin() }}

{#
    documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_verifier_sens_coment_tmj_f_hors_agglo_lin(dept='19') }}
#}
