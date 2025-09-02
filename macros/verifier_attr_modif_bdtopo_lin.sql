{% macro verifier_attr_modif_bdtopo_lin(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 
{% set annee_sfx = annee_str[-2:] %} 
{% set annee_n_1 = var('annee') | int - 1 %}
{% set annee_n_1_str = annee_n_1 | string %}
{% set annee_n_1_sfx = annee_n_1_str[-2:] %} 

select 
t1.id_ign,
t1.nature,t1.coment_cpt,t1.id_comptag,t1.numero as num_n,t2.numero as num_n_1,t1.importance as imp_n,t2.importance as imp_n_1, 
t1.obs_supl as obs_n,t2.obs_supl as obs_n_1
from {{source('traf', 'traf' ~ annee_str ~'_bdt_na_ed' ~ annee_sfx ~ '_l')}} t1
left join {{source('traf', 'traf' ~ annee_n_1_str ~'_bdt_na_ed' ~ annee_n_1_sfx ~ '_l')}} t2
on t1.id_ign=t2.id_ign
where t1.attr_modif is not null
and t1.dept='{{dept}}'
order by t1.id_comptag

{% endmacro %}