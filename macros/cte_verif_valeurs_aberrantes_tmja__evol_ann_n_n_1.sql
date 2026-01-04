{% macro cte_verif_valeurs_aberrantes_tmja__evol_ann_n_n_1(dept=var('dept')) %}

select distinct on (t1.id_comptag) 
    t1.id_comptag,
    t2.nb_ann,
    t1.annee_n,
    t1.annee_n_1,
    t1.annee_n_2,t1.tmja_n,
    t1.tmja_n_1,
    t1.tmja_n_2,
    t1.tmja_n-t1.tmja_n_1 as diff_n_n_1,
    (((t1.tmja_n::numeric - t1.tmja_n_1::numeric)/t1.tmja_n_1::numeric)*100::numeric)::numeric(6,2) as evol_n_n_1,
    t3.suspect,
    t3.obs
  from ({{ cte_verif_valeurs_aberrantes_tmja__ann_n_n_1(dept) }}) t1
  left join (select id_comptag,count(*) as nb_ann 
               from ({{ cte_verif_valeurs_aberrantes_tmja__ann_n_n_1(dept) }}) 
               group by id_comptag) t2 
    on t1.id_comptag=t2.id_comptag
  left join {{ source('cptg', 'comptage') }} t3
    on t1.id_comptag=t3.id_comptag and t1.annee_n=t3.annee
  where t1.tmja_n_1 is not null
  order by t1.id_comptag,t1.annee_n::int desc

{% endmacro %}