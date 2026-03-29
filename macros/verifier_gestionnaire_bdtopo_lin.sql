{% macro verifier_gestionnaire_bdtopo_lin(annee=var('annee'), dept=var('dept')) %}

select
    t.*,
    row_number() over () as id
from
    (
        select distinct
            gestion gestionaire,
            '_{{annee}}' annee
        from
            {{ref('mdl1_creer_vue_' ~ dept)}}
        order by
            gestion
    ) as t
{% endmacro %}