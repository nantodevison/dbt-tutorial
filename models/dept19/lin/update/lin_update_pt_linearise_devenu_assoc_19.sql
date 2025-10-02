{{
  config(
    schema = 'update_auto',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_update_pt_linearise_devenu_assoc_l'
    )
}}

{{ update_pt_linearise_devenu_assoc_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{update_pt_linearise_devenu_assoc_lin(dept='19', annee=2024)}}
#}