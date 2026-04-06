{{
  config(
    schema = 'update',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_vers_estimation_l'
    )
}}

{{ mcr_11_maj_vers_estim_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{mcr_11_maj_vers_estim_lin(dept='19', annee=2024)}}
#}