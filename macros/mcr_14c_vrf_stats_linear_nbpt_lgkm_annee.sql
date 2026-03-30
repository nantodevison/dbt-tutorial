{% macro mcr_14c_vrf_stats_linear_nbpt_lgkm_annee(dept=var('dept')) %}

select count(distinct id_comptag) as nb_pt,round(sum(long_km)::numeric,2) as sum_lg_km,ann_pt 
from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} where src_cpt='otv'
group by ann_pt
order by ann_pt::int desc

{% endmacro %}
