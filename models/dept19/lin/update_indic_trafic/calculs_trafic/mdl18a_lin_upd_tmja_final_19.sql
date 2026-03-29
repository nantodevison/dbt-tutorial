{{
    config(
        schema='update',
        alias = 'traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_tmja_final_l'
    )
}}

{{ mcr_update_tmja_final_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl18a_lin_upd_tmja_final_19(dept='19') }}
#}