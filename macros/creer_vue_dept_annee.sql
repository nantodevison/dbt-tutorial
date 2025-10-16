{% macro creer_vue_dept_annee(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 

SELECT id, id_ign, nature, nom_coll_g, nom_coll_d, numero, importance, cl_admin, gestion, fictif, 
largeur, nb_voies, sens, etat, inseecom_g, inseecom_d, id_voie_g, id_voie_d, urbain, vit_moy_vl, 
restr_p, dept, dept_2024, dept_2023, long_km, coment_cpt, src_cpt, id_comptag, src_cpteur, obs_supl,
 ann_pt, coment_tmj, coment_tmj_f, tmja, tmja_final, veh_km, ann_pc_pl, pc_pl, pl, pl_final, pl_km, 
 obs_tmja, obs_pc_pl, id_cpt1, id_cpt2, obs_tmj1, obs_tmj2, tmja_cpt1, tmja_cpt2, id_sect, src_sect, 
 autor_sect, codau_cat, milieu, codau, type_vdf, vts_vl_vdf, vts_pl_vdf, vts_gest, id_vts, obs_vts, 
 vts_osm, vts_modif, vts_vl_f, vts_pl_f, vts_type_vl, vts_type_pl, src_vma, vma_vl, vma_pl, vma_type, 
 codau_cont, id_codau_cont, tmja_cont, pc_pl_cont, "source", target, cnt_src, cnt_tgt, imp_sup, 
 imp_sup_src, imp_sup_tgt, recup, id_cnt2, id_struct_rout, id_sect_hom, id_simpli, attr_modif, 
 id_bdc, geom, ang_orient_src_vert1, ang_orient_tgt_vert1, list_id_inter, nb_nod_non_topo, id_struct 
FROM {{source('traf', 'traf' ~ annee_str ~ '_bdt_na_ed' ~ annee_str[-2:] ~ '_l')}}
WHERE dept='{{ dept }}'

{% endmacro %}