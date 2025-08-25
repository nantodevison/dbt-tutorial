{% set annee_str = var('annee') | string %} 
{% set annee_str_sfx = annee_str[-2:] %}

{{ config(
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ annee_str_sfx ~ '_l'
) }}

SELECT * 
FROM {{source('traf_2024', 'traf2024_bdt_na_ed24_l')}}
WHERE dept='{{ var('dept') }}'

{#  on peut aussi faire appel à la macro dédiée. 
    Je ne sais pas ce qui est le mieux, dc voici le code 
    d'appell à la macro :
    Dans sa forme basée sur les variables du dbt_project.yml :
    {{ creer_vue_dept_annee() }}
        rappel : dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ creer_vue_dept_annee(annee=2024, dept='19') }}
#}