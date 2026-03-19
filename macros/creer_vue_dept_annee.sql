{% macro creer_vue_dept_annee(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 
{% set annee_sfx = annee_str[-2:] %}
{% set annee_n_1 = (annee - 1) | string %}
{% set annee_n_1_sfx = annee_n_1[-2:] %}

SELECT t1.id, t1.id_ign, t1.nature, t1.nom_coll_g, t1.nom_coll_d, t1.numero, t1.importance, t1.cl_admin, t1.gestion, t1.fictif, 
t1.largeur, t1.nb_voies, t1.sens, t1.etat, t1.inseecom_g, t1.inseecom_d, t1.id_voie_g, t1.id_voie_d, t1.urbain, t1.vit_moy_vl, 
t1.restr_p, t1.dept, t1.dept_{{annee_str}}, t1.dept_{{annee_n_1}}, t1.long_km, t1.coment_cpt, t1.src_cpt, t1.id_comptag, t1.src_cpteur, t1.obs_supl,
 t1.ann_pt, t1.coment_tmj, t1.coment_tmj_f, t1.tmja, t1.tmja_final, t1.veh_km, t1.ann_pc_pl, t1.pc_pl, t1.pl, t1.pl_final, t1.pl_km, 
 t1.obs_tmja, t1.obs_pc_pl, t1.id_cpt1, t1.id_cpt2, t1.obs_tmj1, t1.obs_tmj2, t1.tmja_cpt1, t1.tmja_cpt2, t1.id_sect, t1.src_sect, 
 t1.autor_sect, t1.codau_cat, t1.milieu, t1.codau, t1.type_vdf, t1.vts_vl_vdf, t1.vts_pl_vdf, t1.vts_gest, t1.id_vts, t1.obs_vts, 
 t1.vts_osm, t1.vts_modif, t1.vts_vl_f, t1.vts_pl_f, t1.vts_type_vl, t1.vts_type_pl, t1.src_vma, t1.vma_vl, t1.vma_pl, t1.vma_type, 
 t1.codau_cont, t1.id_codau_cont, t1.tmja_cont, t1.pc_pl_cont, t1."source", t1.target, t1.cnt_src, t1.cnt_tgt, t1.imp_sup, 
 t1.imp_sup_src, t1.imp_sup_tgt, t1.recup, t1.id_cnt2, t1.id_struct_rout, t1.id_sect_hom, t1.id_simpli, t1.attr_modif, 
 t1.id_bdc, t1.geom, t1.ang_orient_src_vert1, t1.ang_orient_tgt_vert1, t1.list_id_inter, t1.nb_nod_non_topo, t1.id_struct 
FROM {{source('traf', 'traf' ~ annee_str ~ '_bdt_na_ed' ~ annee_sfx ~ '_l')}} t1
WHERE dept='{{ dept }}' and not 
        exists (select id_ign 
                  from {{ref('ad_suppr_row_new_millesime')}} t2
                where t1.id_ign=ANY(t2.id_ign) and t2.type_modif='sup' and t2.dept='{{ dept }}' and t2.millesime='{{ annee }}')
UNION
SELECT t3.id, t3.id_ign, t3.nature, t3.nom_coll_g, t3.nom_coll_d, t3.numero, t3.importance, t3.cl_admin, t3.gestion, t3.fictif, 
t3.largeur, t3.nb_voies, t3.sens, t3.etat, t3.inseecom_g, t3.inseecom_d, t3.id_voie_g, t3.id_voie_d, t3.urbain, t3.vit_moy_vl, 
t3.restr_p, t3.dept, t3.dept_{{annee_str}}, t3.dept_{{annee_n_1}}, t3.long_km, t3.coment_cpt, t3.src_cpt, t3.id_comptag, t3.src_cpteur, t3.obs_supl,
 t3.ann_pt, t3.coment_tmj, t3.coment_tmj_f, t3.tmja, t3.tmja_final, t3.veh_km, t3.ann_pc_pl, t3.pc_pl, t3.pl, t3.pl_final, t3.pl_km, 
 t3.obs_tmja, t3.obs_pc_pl, t3.id_cpt1, t3.id_cpt2, t3.obs_tmj1, t3.obs_tmj2, t3.tmja_cpt1, t3.tmja_cpt2, t3.id_sect, t3.src_sect, 
 t3.autor_sect, t3.codau_cat, t3.milieu, t3.codau, t3.type_vdf, t3.vts_vl_vdf, t3.vts_pl_vdf, t3.vts_gest, t3.id_vts, t3.obs_vts, 
 t3.vts_osm, t3.vts_modif, t3.vts_vl_f, t3.vts_pl_f, t3.vts_type_vl, t3.vts_type_pl, t3.src_vma, t3.vma_vl, t3.vma_pl, t3.vma_type, 
 t3.codau_cont, NULL as id_codau_cont, t3.tmja_cont, t3.pc_pl_cont, t3."source", t3.target, t3.cnt_src, t3.cnt_tgt, t3.imp_sup, 
 t3.imp_sup_src, t3.imp_sup_tgt, t3.recup, NULL as id_cnt2, NULL as id_struct_rout, NULL as id_sect_hom, NULL as id_simpli, t3.attr_modif, 
 t3.id_bdc, t3.geom, NULL as ang_orient_src_vert1, NULL as ang_orient_tgt_vert1, NULL as list_id_inter, NULL as nb_nod_non_topo, NULL as id_struct 
FROM {{ref('mdl_ad_troncons_new_millesime')}} t3


{% endmacro %}