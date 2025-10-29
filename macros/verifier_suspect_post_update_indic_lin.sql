{% macro verifier_suspect_post_update_indic_lin(dept=var('dept')) %}

select t1.id_comptag,t1.ann_pt from 
(select distinct id_comptag,ann_pt from {{ref('lin_update_indic_trafic_' ~dept)}} where id_comptag is not null) t1
join (select id_comptag,annee from {{source('cptg', 'comptage')}} where suspect is true) t2
on t1.id_comptag=t2.id_comptag and t1.ann_pt=t2.annee

{% endmacro %}