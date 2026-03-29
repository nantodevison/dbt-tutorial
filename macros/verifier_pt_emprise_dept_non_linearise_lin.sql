{% macro verifier_pt_emprise_dept_non_linearise_lin(annee=var('annee'), dept=var('dept')) %}

select distinct t1.id_comptag from
(select s1.id_comptag from {{source('cptg', 'compteur')}} s1
join {{source('admi', 'dpt_bdt_na_ed'~ (annee | string)[-2:] ~'_s')}} s2 on st_within(s1.geom,s2.geom) where s2.dept='{{dept}}') t1
join (select id_comptag from {{source('cptg', 'comptage')}} where not_lin_why is null) t2
on t1.id_comptag=t2.id_comptag
left join (select distinct id_comptag from {{ref('mdl3b_lin_upd_pt_linear_devenu_assoc_19')}} where id_comptag is not null) t3
on t2.id_comptag=t3.id_comptag
where t3.id_comptag is null

{% endmacro %}