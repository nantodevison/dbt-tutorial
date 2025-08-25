{% macro verifier_gestionnaire_bdtopo_lin(annee=var('annee'), dept=var('dept'), schema='lineaire') %}
{% set annee_str = annee | string %} 
select
    *,
    row_number() over () as id
from
    (
        select distinct
            gestion gestionaire,
            '_{{annee}}' annee
        from
            {{ref('creer_vue_' ~ var('dept'))}}
        order by
            gestion
    )
{% endmacro %}