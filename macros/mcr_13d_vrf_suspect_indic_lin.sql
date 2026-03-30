{% macro mcr_13d_vrf_suspect_indic_lin(dept=var('dept')) %}

select t3.ann_pt , t4.*
 from 
    (select t1.id_comptag,t1.ann_pt 
        from (select distinct id_comptag,ann_pt 
                from {{ref('mdl12i_lin_upd_indic_traf_' ~dept)}} where id_comptag is not null) t1
            join (select id_comptag,annee from {{source('cptg', 'comptage')}} where suspect is true) t2
                on t1.id_comptag=t2.id_comptag and t1.ann_pt=t2.annee) t3 
    join ({{cte1_mcr_13d_vrf_histo_traf_lin()}}) t4 on t3.id_comptag=t4.id_comptag

{% endmacro %}