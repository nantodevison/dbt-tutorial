{% macro verifier_dept_limitrophe_lin(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 
{% set annee_sfx = annee_str[-2:] %} 

select distinct t1.insee_dep from
(select insee_dep,geom from {{ source('admi', 'com_bdt_na_ed' ~ annee_sfx ~ '_s') }}) t1 join
(select gid,dept,geom from {{source('admi', 'dpt_bdt_na_ed' ~ annee_sfx ~ '_s')}} where dept='{{dept}}') t2  
on st_intersects(t1.geom,t2.geom)
where t1.insee_dep<>'{{dept}}' and t1.insee_dep not in (
    {% for d in var('dept_na') %}
      '{{ d }}'{% if not loop.last %}, {% endif %}
    {% endfor %}
  )
order by t1.insee_dep
{% endmacro %}