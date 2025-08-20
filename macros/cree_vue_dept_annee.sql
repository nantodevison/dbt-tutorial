{% macro create_vue_dept_annee(annee, dept) %}
{% set annee_str = annee | string %} 

SELECT * 
FROM lineaire.traf{{ annee }}_bdt_na_ed{{ annee_str[-2:] }}_l 
WHERE dept='{{ dept }}'

{% endmacro %}