{{
    config(
        schema='update',
        alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_coment_cpt_l'
    )
}}

{{ mcr_update_coment_cpt_lin() }}   

{# 
documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_update_coment_cpt_19(dept='19') }}
#}