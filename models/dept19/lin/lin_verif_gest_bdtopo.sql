{{ config(
    schema='verif',
)}}

{% set annee_str = var('annee') | string %} 

select
    *,
    row_number() over () as id
from
    (
        select distinct
            gestion gestionaire,
            '_{{annee}}' annee
        from
            lineaire.traf{{annee_str}}_bdt{{var('dept')}}_ed{{annee_str[-2:]}}_l
        order by
            gestion
    )

{#  on peut aussi faire appel à la macro dédiée. 
    Je ne sais pas ce qui est le mieux, dc voici le code 
    d'appell à la macro :
    Dans sa forme basée sur les variables du dbt_project.yml :
        {{verifier_gestionnaire_bdtopo_lin()}}
        rappel : dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{verifier_gestionnaire_bdtopo_lin(annee=2024, dept='19')}}
#}