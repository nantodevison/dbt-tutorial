{% macro creer_vue_dept_annee(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 

SELECT * 
FROM {{source('traf', 'traf' ~ annee_str ~ '_bdt_na_ed' ~ annee_str[-2:] ~ '_l')}}
WHERE dept='{{ dept }}'

{% endmacro %}