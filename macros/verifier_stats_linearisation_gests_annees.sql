{% macro verifier_stats_linearisation_gests_annees(dept=var('dept')) %}

select gestionnai,string_agg(ann_pt||':'||nb_pt,';') as ann_nb_pt
from (
{{verifier_stats_linearisation_nbpt_gest(dept, true)}})
group by gestionnai

{% endmacro %}