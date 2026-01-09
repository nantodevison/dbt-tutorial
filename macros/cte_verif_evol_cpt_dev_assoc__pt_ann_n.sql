{% macro cte_verif_evol_cpt_dev_assoc__pt_ann_n(dept=var('dept'), annee=var('annee')) %}
{% set annee_n_1 = (annee | int - 1) | string %}

select t1.* -- t1.id_comptag, t1.ann_pt as ann_lin_n_1, t1.tmja as tmja_lin_n_1
from ({{cte_verif_evol_cpt_dev_assoc__id_cptg_n_1(dept=dept, annee=annee)}}) as t1
  left join ({{cte_verif_evol_cpt_dev_assoc__id_cptg_n(dept=dept)}}) as t2
on t1.id_comptag = t2.id_comptag
where t2.id_comptag is null

{% endmacro %}