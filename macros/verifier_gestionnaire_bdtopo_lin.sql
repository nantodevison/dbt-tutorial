{% macro verifier_gestionnaire_bdtopo_lin(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 
select
    t.*,
    row_number() over () as id
from
    (
        select distinct
            gestion gestionaire,
            '_{{annee}}' annee
        from
            {{ref('creer_vue_' ~ dept)}}
        order by
            gestion
    ) as t
{% endmacro %}