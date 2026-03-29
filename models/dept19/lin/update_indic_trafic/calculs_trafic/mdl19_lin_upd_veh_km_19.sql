{{
    config(
        schema='update',
        alias = 'traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_veh_km_l'
    )
}}

{{ mcr_update_veh_km_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl19_lin_upd_veh_km_19(dept='19') }}
#}