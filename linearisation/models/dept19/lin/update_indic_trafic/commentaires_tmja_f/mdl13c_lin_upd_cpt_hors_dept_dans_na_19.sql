{{ config(
    schema='update',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_cpt_hors_dept_dans_na_l'
) }}

{{mcr_13c_maj_cpt_hors_dept_dans_na_lin()}}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ mdl13c_lin_upd_cpt_hors_dept_dans_na_19(dept='19') }}
#}