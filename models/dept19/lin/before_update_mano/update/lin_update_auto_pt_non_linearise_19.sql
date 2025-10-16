{{ config(
    schema='update',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_update_auto_pt_non_linearise_l'
) }}

{{update_auto_pt_non_linearise_lin()}}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{update_auto_pt_non_linearise_lin(dept='19', annee=2024)}}
#}
