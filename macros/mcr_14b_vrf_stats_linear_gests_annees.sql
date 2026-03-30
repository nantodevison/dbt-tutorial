{% macro mcr_14b_vrf_stats_linear_gests_annees(dept=var('dept')) %}

select gestionnai,string_agg(ann_pt||':'||nb_pt,';') as ann_nb_pt
from (
{{mcr_14a_vrf_stats_linear_nbpt_gest(dept, true)}})
group by gestionnai

{% endmacro %}