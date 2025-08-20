{% set annee_str = var('annee') | string %} 
{% set annee_str_sfx = annee_str[-2:] %} 
{{ config(
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ annee_str_sfx ~ '_l'
) }}

{{ creer_vue_dept_annee() }}