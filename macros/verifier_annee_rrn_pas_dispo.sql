{% macro verifier_annee_rrn_pas_dispo(dept=var('dept'), annee=var('annee')) %}

select distinct id_comptag,ann_pt,tmja,ann_pc_pl,pc_pl 
from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} 
where ann_pt::int<{{ annee }} and (id_comptag like '%-N%' or id_comptag like '%-A%')

{% endmacro %}