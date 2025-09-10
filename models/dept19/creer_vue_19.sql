{{ config(
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_l'
) }}

{{creer_vue_dept_annee()}}

{#  documentation d'utilisation :
        appel : dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ creer_vue_dept_annee(annee=2024, dept='19') }}
#}