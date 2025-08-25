{{ config(
    schema='verif',
)}}

SELECT coment_cpt,nature,round((sum(long_km))::numeric,2) as sum_lg_km, count(*) cnt 
FROM {{ref('creer_vue_' ~ var('dept'))}} 
WHERE nature NOT IN {{var('nature_verif')}}
GROUP BY coment_cpt, nature

{#  on peut aussi faire appel à la macro dédiée. 
    Je ne sais pas ce qui est le mieux, dc voici le code 
    d'appell à la macro :
    Dans sa forme basée sur les variables du dbt_project.yml :
    {{ verifier_nature_bdtopo_lin() }}
        rappel : dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ verifier_nature_bdtopo_lin(annee=2024, dept='19') }}
#}