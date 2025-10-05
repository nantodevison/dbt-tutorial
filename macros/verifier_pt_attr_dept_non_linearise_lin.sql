{% macro verifier_pt_attr_dept_non_linearise_lin(dept=var('dept')) %}

select distinct t1.id_comptag,t1.dep,t1.annee_tmja,t1.not_lin_why,t1.geom
from
(select s1.id_comptag,s2.dep,s1.annee_tmja,s1.not_lin_why,s1.geom from {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} s1
join {{source('cptg', 'compteur')}} s2 on s1.id_comptag=s2.id_comptag
where s2.dep='{{dept}}' and s1.not_lin_why is null) t1
left join
(select distinct id_comptag from {{ref('lin_update_pt_linearise_devenu_assoc_' ~ dept)}} where id_comptag is not null) t2
on t1.id_comptag=t2.id_comptag
where t2.id_comptag is null
order by t1.id_comptag

{% endmacro %}