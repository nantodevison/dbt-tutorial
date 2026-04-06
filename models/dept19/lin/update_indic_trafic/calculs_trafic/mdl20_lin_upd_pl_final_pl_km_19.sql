{{ 
    config(
        schema='update',
        alias = 'traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_pl_final_pl_km_l'
    )
}}

{{ mcr_20_maj_pl_final_pl_km_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl20_lin_upd_pl_final_pl_km_19(dept='19') }}
#}