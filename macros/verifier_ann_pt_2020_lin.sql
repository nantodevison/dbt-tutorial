{% macro verifier_ann_pt_2020_lin(dept=var('dept')) %}

select distinct id_comptag 
    from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }}
    where ann_pt='2020' 
    order by id_comptag

{% endmacro %}
