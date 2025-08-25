{% macro verifier_nbpt_lgkm_lin(annee=var('annee'), dept=var('dept'), schema='lineaire') %}
{% set annee_str = annee | string %} 
    select count(distinct id_comptag) as nb_pt,
           round(sum(long_km)::numeric) as sum_lg_km
    from {{ref('creer_vue_' ~ var('dept'))}}
    where id_comptag is not null
{% endmacro %}
