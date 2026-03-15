{% macro verifier_valeurs_aberrantes_tmja(dept=var('dept'), 
    seuil_evol=var('seuil_evol_tmja_verif'),
    seuil_diff=var('seuil_diff_tmja_verif'), 
    ann_n_filter=var('annee'), 
    ann_n_1_filter=none, 
    id_comptag_like=none,
    percentile_value=none) %}

SELECT {% if not percentile_value %} * {% else %} PERCENTILE_DISC({{percentile_value}}) WITHIN GROUP(ORDER BY t.evol_n_n_1) as percentile_value {% endif %}
FROM ({{ cte_verif_valeurs_aberrantes_tmja__evol_ann_n_n_1(dept=dept) }}) t
where abs(t.evol_n_n_1) > {{seuil_evol}} and abs(t.diff_n_n_1) > {{seuil_diff}} and t.annee_n = '{{ann_n_filter}}'
{% if id_comptag_like %} and t.id_comptag like '{{id_comptag_like}}' {% endif %}
{% if ann_n_1_filter %} and t.annee_n_1='{{ann_n_1_filter}}' {% endif %}

{% endmacro %}