{{ config(
    schema='verif',
)}}

{% set annee_str = var('annee') | string %} 

select count(distinct id_comptag) as nb_pt,
       round(sum(long_km)::numeric) as sum_lg_km
from lineaire.traf{{ annee_str }}_bdt{{ var('dept') }}_ed{{ annee_str[-2:] }}_l
where id_comptag is not null

{#  on peut aussi faire appel à la macro dédiée. 
    Je ne sais pas ce qui est le mieux, dc voici le code 
    d'appell à la macro :
    Dans sa forme basée sur les variables du dbt_project.yml :
    {{ verifier_nbpt_lgkm_lin() }}
        rappel : dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ verifier_nbpt_lgkm_lin(annee=2024, dept='19') }}
#}