{{
  config(
    schema = 'affectation_pt_mano',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_modif_linearisation_l'
    )
}}

{{ update_modif_linearisation_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", annee: "2024"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{update_modif_linearisation_lin(dept='19', annee=2024)}}
#}