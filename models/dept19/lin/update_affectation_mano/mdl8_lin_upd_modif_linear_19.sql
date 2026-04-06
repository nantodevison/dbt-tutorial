{{
  config(
    schema = 'update',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_modif_linearisation_l'
    )
}}

{{ mcr_8_maj_modif_linear_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", annee: "2024"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{mcr_8_maj_modif_linear_lin(dept='19', annee=2024)}}
#}