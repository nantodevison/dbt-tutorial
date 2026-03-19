{% macro mcr_ajouter_troncon_nouveau_millesime(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 
{% set annee_sfx = annee_str[-2:] %}
{% set annee_n_1 = (annee - 1) | string %}
{% set annee_n_1_sfx = annee_n_1[-2:] %}

WITH
    ad as (
    select t1.id_ign,t1.id_propa,t1.type_modif,t2.geom 
      from (select id_ign,id_propa,type_modif
            from {{ref('ad_suppr_row_new_millesime')}} 
            where type_modif='ad' and dept='{{dept}}' and millesime='{{annee}}') t1
        left join (select id_ign,geom 
                     from {{source('traf', 'traf' ~ annee_str ~ '_bdt_na_ed' ~ annee_sfx ~ '_l')}}) t2 on t2.id_ign=ANY(t1.id_ign)
      where t2.id_ign is null)

        --verif si db de codau_cat
	--select t1.id_ign, count(*) as cnt from ad t1 join aire.au_na_ed23_s t2 on st_intersects(t1.geom,t2.geom)  group by id_ign order by cnt desc
	
	,traf_bdt_maj as (
        select t2.id, t2.id_ign,t2.nature,t2.nom_coll_g,t2.nom_coll_d,t2.numero,t2.importance,t2.cl_admin,t2.gestion,
	t2.fictif,t2.largeur,t2.nb_voies,t2.sens,t2.etat,
	t2.inseecom_g,t2.inseecom_d,t2.id_voie_g,t2.id_voie_d,
	t2.urbain,t2.vit_moy_vl,t2.restr_p,
	CASE WHEN t2.dept_{{annee_str}} is not null then t2.dept_{{annee_str}} WHEN t2.dept_{{annee_str}} is null and t3.dept is not null then t3.dept else null end as dept,
	t2.dept_{{annee_str}},t3.dept as dept_{{annee_n_1}},
	st_length(t2.geom)/1000 as long_km, t3.coment_cpt,t3.src_cpt,t3.id_comptag,t3.src_cpteur,t3.obs_supl,t3.ann_pt,t3.ann_pc_pl,
	t3.coment_tmj_f as coment_tmj,
	CASE WHEN t2.sens='{{var("bdtopo_double_sens_verif")}}' then null
	WHEN t2.sens=ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then '/2'
	else null end as coment_tmj_f,
	t3.tmja,
	CASE WHEN t2.sens=ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then round(t3.tmja::numeric/2.0)::integer
	WHEN t2.sens='{{var("bdtopo_double_sens_verif")}}' then t3.tmja else t3.tmja_final end as tmja_final,
	t3.pc_pl,
	CASE WHEN t2.sens=ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then round(t3.tmja::numeric/2.0)::numeric*(st_length(t2.geom)/1000::numeric)
	WHEN t2.sens='{{var("bdtopo_double_sens_verif")}}' then t3.tmja::numeric*(st_length(t2.geom)/1000::numeric) 
	else t3.tmja_final*(st_length(t2.geom)/1000::numeric) end as veh_km,
	t3.pl,
	CASE WHEN t2.sens=ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then round(t3.pl::numeric/2.0)::integer
	WHEN t2.sens='{{var("bdtopo_double_sens_verif")}}' then t3.pl else t3.pl_final end as pl_final,
	CASE WHEN t2.sens=ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then round(t3.pl::numeric/2.0)::numeric*(st_length(t2.geom)/1000::numeric)
	WHEN t2.sens='{{var("bdtopo_double_sens_verif")}}' then t3.pl::numeric*(st_length(t2.geom)/1000::numeric) else t3.pl_final::numeric*(st_length(t2.geom)/1000::numeric) end as pl_km,
	t3.obs_tmja,t3.obs_pc_pl,t3.id_cpt1,t3.id_cpt2,t3.obs_tmj1,t3.obs_tmj2,t3.tmja_cpt1,t3.tmja_cpt2,
	t3.id_sect,t3.src_sect,t3.autor_sect,t3.codau_cat,t3.milieu,t3.codau,
	t3.type_vdf,t3.vts_vl_vdf,t3.vts_pl_vdf,t3.vts_gest,t3.id_vts,t3.obs_vts,t3.vts_osm,
	t3.vts_modif,t3.vts_vl_f,t3.vts_pl_f,t3.vts_type_vl,t3.vts_type_pl,t3.src_vma,t3.vma_vl,t3.vma_pl,t3.vma_type,
	t3.codau_cont,t3.tmja_cont,t3.pc_pl_cont,
	t2.source,t2.target,
	t1.type_modif as recup,
	null as attr_modif,
	null::int as cnt_src,null::int as cnt_tgt,null as imp_sup,null as imp_sup_src,null as imp_sup_tgt,
	null::text[] as id_bdc,
	t2.geom
	from ad t1
	left join {{source('ref','troncon_route_bdt_na_ed' ~ annee_sfx ~ '_l')}} t2 on t2.id_ign=ANY(t1.id_ign) --double left join si erreur id_propa=id_ign dans present dans attributs metier annee N
	left join {{source('traf', 'traf' ~ annee_str ~ '_bdt_na_ed' ~ annee_sfx ~ '_l')}} t3 on t1.id_propa=t3.id_ign) --jointure id_propa avec id_ign annee pour avoir attributs metier annee N
    select id, id_ign,nature,nom_coll_g,nom_coll_d,numero,importance,cl_admin,gestion,
	fictif,largeur,nb_voies,sens, etat,
	inseecom_g,inseecom_d,id_voie_g,id_voie_d,
	urbain,vit_moy_vl,restr_p, 
	dept,dept_{{annee_str}},dept_{{annee_n_1}},
	long_km,coment_cpt,src_cpt,id_comptag,src_cpteur,obs_supl,ann_pt,ann_pc_pl,
	coment_tmj,coment_tmj_f, 
	tmja, tmja_final,pc_pl,veh_km,pl,pl_final,pl_km,
	obs_tmja,obs_pc_pl,id_cpt1,id_cpt2,obs_tmj1,obs_tmj2,tmja_cpt1,tmja_cpt2,
	id_sect,src_sect,autor_sect,codau_cat,milieu,codau,type_vdf,
	vts_vl_vdf,vts_pl_vdf,vts_gest,id_vts,obs_vts,vts_osm,vts_modif,
	vts_vl_f,vts_pl_f,vts_type_vl,vts_type_pl,src_vma,vma_vl,vma_pl,vma_type,
	codau_cont, tmja_cont,pc_pl_cont,source,target,recup,attr_modif,
	cnt_src,cnt_tgt,imp_sup,imp_sup_src,imp_sup_tgt,id_bdc,
	geom from traf_bdt_maj

{% endmacro %}