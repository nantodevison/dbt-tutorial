{% set annee_str = var('annee') | string %} 
{% set annee_str_sfx = annee_str[-2:] %} 
{{ config(
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ annee_str_sfx ~ '_l'
) }}

SELECT * 
FROM {{source('traf_2024', 'traf2024_bdt_na_ed24_l')}}
WHERE dept='{{ var('dept') }}'