{% macro mcr_16c_vrf_ann_cptgassoc_cptgref_lin(dept=var('dept')) %}

select t1.id_comptag,
       t2.type_poste,
       t1.tmja,
       t1.ann_pt,
       coalesce(t2.periode,'NULL') as periode,
       t3.id_cpteur_asso,
       t3.type_poste as type_poste_asso,
       t3.tmja as tmja_asso,
       t3.annee_tmja as annee_tmja_asso,
       coalesce(t3.periode,'NULL') as periode_asso
  from (select distinct id_comptag,ann_pt,tmja 
          from {{ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept)}} where coment_cpt='linearisation') t1
            join {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} t2 using(id_comptag)
    join {{source('cptg_assoc', 'vue_assoc_compteur_last_annee_know_tmja_pc_pl')}} t3 on t1.id_comptag=t3.id_cpteur_ref
  where t3.annee_tmja::int>t1.ann_pt::int

{% endmacro %}