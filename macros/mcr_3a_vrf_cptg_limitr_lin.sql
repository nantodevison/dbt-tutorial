{% macro mcr_3a_vrf_cptg_limitr_lin(annee=var('annee'), dept=var('dept')) %}
select c.gid, c.id_comptag, c.route, c.type_poste, c.annee_tmja, c.tmja, c.pc_pl, c.annee_pc_pl, c.geom, c.gestionnai
from {{ source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl') }} c
join {{ ref('mdl2b_lin_chk_dept_limitr_' ~ dept) }} l
  on c.dep = l.insee_dep
{% endmacro %}