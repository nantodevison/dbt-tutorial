{% macro verifier_pt_linearise_absent_comptage_lin(dept=var('dept')) %}

select t1.id_comptag, 
       case when t3.id_cpteur_asso is not null then true 
       else false 
       end::boolean is_assoc, 
       t3.id_cpteur_ref
from
(select distinct id_comptag,ann_pt from {{ref('mdl1_creer_vue_'~ dept)}} where src_cpt='otv' ) t1
left join {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} t2 on t1.id_comptag=t2.id_comptag
left join {{source('cptg_assoc', 'compteur')}} t3 on t1.id_comptag=t3.id_cpteur_asso
where t2.id_comptag is null

{% endmacro %}