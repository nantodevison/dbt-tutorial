{{
  config(
    schema = 'update',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_etirer_linearisation_l'
    )
}}

{{ mcr_10_maj_etirer_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{mcr_10_maj_etirer_lin(dept='19', annee=2024)}}
#}