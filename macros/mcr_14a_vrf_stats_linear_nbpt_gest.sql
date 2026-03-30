{% macro mcr_14a_vrf_stats_linear_nbpt_gest(dept=var('dept'), annee=false) %}


select count(*) as  nb_pt,t2.gestionnai{% if annee %},t1.ann_pt{% endif %}
from (select distinct id_comptag,ann_pt 
        from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} 
        where src_cpt='otv') t1
join {{source('cptg','compteur')}} t2 using (id_comptag)
group by t2.gestionnai{% if annee %},t1.ann_pt{% endif %} order by {% if annee %}t2.gestionnai,t1.ann_pt{% else %}nb_pt{% endif %} desc

{% endmacro %}