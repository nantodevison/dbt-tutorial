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
            lineaire.traf{{annee}}_bdt{{dept}}_ed{{annee_str[-2:]}}_l
        order by
            gestion
    )
{% endmacro %}