{{ config(
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_linearisation_final_l',
) }}

{{mcr_vue_lin_finale()}}

{#  documentation d'utilisation :
        appel : dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ creer_vue_linearisation_19(dept='19') }}
#}