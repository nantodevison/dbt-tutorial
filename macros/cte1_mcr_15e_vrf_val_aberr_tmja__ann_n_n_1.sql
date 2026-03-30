{% macro cte1_mcr_15e_vrf_val_aberr_tmja__ann_n_n_1(dept=var('dept')) %}

select t1.id_comptag,
       t1.annee as annee_n,
       t1.tmja as tmja_n,
       LEAD(t1.annee)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as annee_n_1,
       LEAD(t1.annee,2)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as annee_n_2,
       LEAD(t1.tmja)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as tmja_n_1,
       LEAD(t1.tmja,2)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as tmja_n_2
  from {{source('cptg', 'vue_evolutions_tmja')}} t1
  join (select distinct id_comptag 
          from {{ ref('mdl14e_lin_upd_cmt_tmj_f_lui_mm_' ~ dept)}}
          where src_cpt='otv') t2 
    on t1.id_comptag=t2.id_comptag
  order by t1.id_comptag,t1.annee::int desc

{% endmacro %}