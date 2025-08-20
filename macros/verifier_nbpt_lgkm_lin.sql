{% macro verifier_nbpt_lgkm_lin(annee=var('annee'), dept=var('dept'), schema='lineaire') %}
{% set annee_str = annee | string %} 
    select count(distinct id_comptag) as nb_pt,
           round(sum(long_km)::numeric) as sum_lg_km
    from {{ schema }}.traf{{ annee }}_bdt{{ dept }}_ed{{ annee_str[-2:] }}_l
    where id_comptag is not null
{% endmacro %}
