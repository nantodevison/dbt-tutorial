{% macro mcr_xx_aj_tronc_nouv_mill(annee=var('annee'), dept=var('dept')) %}
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

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_1_creer_vue_dept_annee(annee=var('annee'), dept=var('dept')) %}
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

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_2a_vrf_attr_modif_bdt_lin(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 
{% set annee_sfx = annee_str[-2:] %} 
{% set annee_n_1 = var('annee') | int - 1 %}
{% set annee_n_1_str = annee_n_1 | string %}
{% set annee_n_1_sfx = annee_n_1_str[-2:] %} 

select 
t1.id_ign,
t1.nature,t1.coment_cpt,t1.id_comptag,t1.numero as num_n,t2.numero as num_n_1,t1.importance as imp_n,t2.importance as imp_n_1, 
t1.obs_supl as obs_n,t2.obs_supl as obs_n_1
from {{ref('mdl1_creer_vue_' ~ dept)}} t1
left join {{source('traf', 'traf' ~ annee_n_1_str ~'_bdt_na_ed' ~ annee_n_1_sfx ~ '_l')}} t2
on t1.id_ign=t2.id_ign
where t1.attr_modif is not null
and t2.dept='{{dept}}'
order by t1.id_comptag

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_2b_vrf_dept_limitr_lin(annee=var('annee'), dept=var('dept')) %}
{% set annee_str = annee | string %} 
{% set annee_sfx = annee_str[-2:] %} 

select distinct t1.insee_dep from
(select insee_dep,geom from {{ source('admi', 'com_bdt_na_ed' ~ annee_sfx ~ '_s') }}) t1 join
(select gid,dept,geom from {{source('admi', 'dpt_bdt_na_ed' ~ annee_sfx ~ '_s')}} where dept='{{dept}}') t2  
on st_intersects(t1.geom,t2.geom)
where t1.insee_dep<>'{{dept}}' and t1.insee_dep not in (
    {% for d in var('dept_na') %}
      '{{ d }}'{% if not loop.last %}, {% endif %}
    {% endfor %}
  )
order by t1.insee_dep
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_2e_cmp_gest_bdt_lin(annee1, annee2, dept) %}
with
annee_n as ({{mcr_xx_vrf_gest_bdt_lin(annee=annee1, dept=dept)}}),
annee_n_1 as ({{mcr_xx_vrf_gest_bdt_lin(annee=annee2, dept=dept)}}),
row_union as (
        select
            *
        from
            annee_n
        union all
        select
            *
        from
            annee_n_1
    )
SELECT
    MAX(
        CASE
            WHEN annee = '_{{annee1}}' THEN gestionaire
            ELSE NULL
        END
    ) AS gestionnaire_annee_n,
    MAX(
        CASE
            WHEN annee = '_{{annee2}}' THEN gestionaire
            ELSE NULL
        END
    ) AS gestionnaire_annee_2
FROM
    (
        select
            annee,
            gestionaire,
            ROW_NUMBER() OVER (
                PARTITION BY
                    annee
                ORDER BY
                    id
            ) as row_id
        from
            row_union
    ) DS
GROUP BY
    row_id
ORDER BY
    row_id
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_xx_vrf_gest_bdt_lin(annee=var('annee'), dept=var('dept')) %}

select
    t.*,
    row_number() over () as id
from
    (
        select distinct
            gestion gestionaire,
            '_{{annee}}' annee
        from
            {{ref('mdl1_creer_vue_' ~ dept)}}
        order by
            gestion
    ) as t
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_2f_vrf_nature_bdt_lin(dept=var('dept')) %}

SELECT coment_cpt,nature,round((sum(long_km))::numeric,2) as sum_lg_km, count(*) cnt 
FROM {{ref('mdl1_creer_vue_' ~ dept)}} 
WHERE nature != ALL(ARRAY{{var('nature_verif')}})
GROUP BY coment_cpt, nature
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_2g_vrf_nbpt_lgkm_lin(dept=var('dept')) %}

    select count(distinct id_comptag) as nb_pt,
           round(sum(long_km)::numeric) as sum_lg_km
    from {{ref('mdl1_creer_vue_' ~ dept)}}
    where id_comptag is not null
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_2h_vrf_pt_linear_absent_cptg_lin(dept=var('dept')) %}

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

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_2i_vrf_pt_sans_geom_lin(dept=var('dept')) %}

select distinct on (t2.id_comptag) t2.id_comptag,
t3.gestionnai,t3.type_poste,t2.annee,t2.periode,t1.id, t1.id_comptag_uniq, t1.indicateur, t1.valeur, t1.fichier
from {{source('cptg', 'indic_agrege')}} t1 
join {{source('cptg', 'comptage')}} t2 on t1.id_comptag_uniq=t2.id
join {{source('cptg', 'compteur')}} t3 on t2.id_comptag=t3.id_comptag
where t3.dep='{{ dept }}' and t1.indicateur='tmja' and t3.geom is null
order by t2.id_comptag,t2.annee desc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_3a_vrf_cptg_limitr_lin(annee=var('annee'), dept=var('dept')) %}
select c.gid, c.id_comptag, c.route, c.type_poste, c.annee_tmja, c.tmja, c.pc_pl, c.annee_pc_pl, c.geom, c.gestionnai
from {{ source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl') }} c
join {{ ref('mdl2b_lin_chk_dept_limitr_' ~ dept) }} l
  on c.dep = l.insee_dep
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_3b_maj_pt_linear_devenu_assoc_lin(annee=var('annee'), dept=var('dept')) %}
{% set annee_prec = annee | int - 1 %}

select 
    -- Colonnes de la vérification : récup de l'id_comptag de référence
    vpl.id_cpteur_ref id_comptag,
    -- Toutes les autres colonnes du modèle mdl1_creer_vue_19
    cv.id,
    cv.id_ign,
    cv.nature,
    cv.nom_coll_g,
    cv.nom_coll_d,
    cv.numero,
    cv.importance,
    cv.cl_admin,
    cv.gestion,
    cv.fictif,
    cv.largeur,
    cv.nb_voies,
    cv.sens,
    cv.etat,
    cv.inseecom_g,
    cv.inseecom_d,
    cv.id_voie_g,
    cv.id_voie_d,
    cv.urbain,
    cv.vit_moy_vl,
    cv.restr_p,
    cv.dept,
    cv.dept_2024,
    cv.dept_2023,
    cv.long_km,
    'otv' src_cpt,
    'linearisation' coment_cpt,
    cv.ann_pt,
    cv.src_cpteur,
    cv.coment_tmj,
    cv.coment_tmj_f,
    cv.ann_pc_pl,
    cv.tmja,
    cv.pc_pl,
    cv.veh_km,
    cv.tmja_final,
    cv.pl,
    cv.pl_final,
    cv.pl_km,
    cv.id_cpt1,
    cv.id_cpt2,
    cv.obs_tmj1,
    cv.obs_tmj2,
    cv.tmja_cpt1,
    cv.tmja_cpt2,
    cv.codau_cat,
    cv.milieu,
    cv.codau,
    cv.type_vdf,
    cv.vts_vl_vdf,
    cv.vts_pl_vdf,
    cv.vts_gest,
    cv.id_vts,
    cv.obs_tmja,
    cv.obs_pc_pl,
    case when cv.obs_supl is not null and cv.obs_supl like 'ex %' then 'ex '||cv.id_comptag||' traf{{annee_prec}},'||cv.obs_supl
		when cv.obs_supl is not null then 'ex '||cv.id_comptag||' traf{{annee_prec}},ex '||cv.obs_supl
		else 'ex '||cv.id_comptag||' traf{{annee_prec}}' end obs_supl,
    cv.id_sect,
    cv.src_sect,
    cv.autor_sect,
    cv.obs_vts,
    cv.vts_osm,
    cv.vts_modif,
    cv.vts_vl_f,
    cv.vts_pl_f,
    cv.vts_type_vl,
    cv.vts_type_pl,
    cv.src_vma,
    cv.vma_vl,
    cv.vma_pl,
    cv.vma_type,
    cv.codau_cont,
    cv.id_codau_cont,
    cv.tmja_cont,
    cv.pc_pl_cont,
    cv."source",
    cv.target,
    cv.cnt_src,
    cv.cnt_tgt,
    cv.imp_sup,
    cv.imp_sup_src,
    cv.imp_sup_tgt,
    cv.recup,
    cv.id_cnt2,
    cv.id_struct_rout,
    cv.id_sect_hom,
    cv.id_simpli,
    cv.attr_modif,
    cv.id_bdc,
    cv.geom,
    cv.ang_orient_src_vert1,
    cv.ang_orient_tgt_vert1,
    cv.list_id_inter,
    cv.nb_nod_non_topo,
    cv.id_struct
from {{ref('mdl2h_lin_chk_pt_linear_absent_cptge_' ~ dept)}} vpl 
join {{ref('mdl1_creer_vue_' ~ dept)}} cv 
    on vpl.id_comptag = cv.id_comptag
UNION
-- Lignes de mdl1_creer_vue_19 non présentes dans la verif
select 
    cv.id_comptag,
    cv.id,
    cv.id_ign,
    cv.nature,
    cv.nom_coll_g,
    cv.nom_coll_d,
    cv.numero,
    cv.importance,
    cv.cl_admin,
    cv.gestion,
    cv.fictif,
    cv.largeur,
    cv.nb_voies,
    cv.sens,
    cv.etat,
    cv.inseecom_g,
    cv.inseecom_d,
    cv.id_voie_g,
    cv.id_voie_d,
    cv.urbain,
    cv.vit_moy_vl,
    cv.restr_p,
    cv.dept,
    cv.dept_2024,
    cv.dept_2023,
    cv.long_km,
    cv.src_cpt,
    cv.coment_cpt,
    cv.ann_pt,
    cv.src_cpteur,
    cv.coment_tmj,
    cv.coment_tmj_f,
    cv.ann_pc_pl,
    cv.tmja,
    cv.pc_pl,
    cv.veh_km,
    cv.tmja_final,
    cv.pl,
    cv.pl_final,
    cv.pl_km,
    cv.id_cpt1,
    cv.id_cpt2,
    cv.obs_tmj1,
    cv.obs_tmj2,
    cv.tmja_cpt1,
    cv.tmja_cpt2,
    cv.codau_cat,
    cv.milieu,
    cv.codau,
    cv.type_vdf,
    cv.vts_vl_vdf,
    cv.vts_pl_vdf,
    cv.vts_gest,
    cv.id_vts,
    cv.obs_tmja,
    cv.obs_pc_pl,
    cv.obs_supl,
    cv.id_sect,
    cv.src_sect,
    cv.autor_sect,
    cv.obs_vts,
    cv.vts_osm,
    cv.vts_modif,
    cv.vts_vl_f,
    cv.vts_pl_f,
    cv.vts_type_vl,
    cv.vts_type_pl,
    cv.src_vma,
    cv.vma_vl,
    cv.vma_pl,
    cv.vma_type,
    cv.codau_cont,
    cv.id_codau_cont,
    cv.tmja_cont,
    cv.pc_pl_cont,
    cv."source",
    cv.target,
    cv.cnt_src,
    cv.cnt_tgt,
    cv.imp_sup,
    cv.imp_sup_src,
    cv.imp_sup_tgt,
    cv.recup,
    cv.id_cnt2,
    cv.id_struct_rout,
    cv.id_sect_hom,
    cv.id_simpli,
    cv.attr_modif,
    cv.id_bdc,
    cv.geom,
    cv.ang_orient_src_vert1,
    cv.ang_orient_tgt_vert1,
    cv.list_id_inter,
    cv.nb_nod_non_topo,
    cv.id_struct
from {{ref('mdl1_creer_vue_' ~ dept)}} cv
where not exists (
    select 1 
    from {{ref('mdl2h_lin_chk_pt_linear_absent_cptge_' ~ dept)}} vpl
    where vpl.id_comptag = cv.id_comptag)

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_4a_vrf_pt_attr_dept_non_linear_lin(dept=var('dept')) %}

select distinct t1.id_comptag,t1.dep,t1.annee_tmja,t1.not_lin_why,t1.geom
from
(select s1.id_comptag,s2.dep,s1.annee_tmja,s1.not_lin_why,s1.geom from {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} s1
join {{source('cptg', 'compteur')}} s2 on s1.id_comptag=s2.id_comptag
where s2.dep='{{dept}}' and s1.not_lin_why is null) t1
left join
(select distinct id_comptag from {{ref('mdl3b_lin_upd_pt_linear_devenu_assoc_' ~ dept)}} where id_comptag is not null) t2
on t1.id_comptag=t2.id_comptag
where t2.id_comptag is null
order by t1.id_comptag

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_4b_vrf_pt_emprise_dept_non_linear_lin(annee=var('annee'), dept=var('dept')) %}

select distinct t1.id_comptag from
(select s1.id_comptag from {{source('cptg', 'compteur')}} s1
join {{source('admi', 'dpt_bdt_na_ed'~ (annee | string)[-2:] ~'_s')}} s2 on st_within(s1.geom,s2.geom) where s2.dept='{{dept}}') t1
join (select id_comptag from {{source('cptg', 'comptage')}} where not_lin_why is null) t2
on t1.id_comptag=t2.id_comptag
left join (select distinct id_comptag from {{ref('mdl3b_lin_upd_pt_linear_devenu_assoc_19')}} where id_comptag is not null) t3
on t2.id_comptag=t3.id_comptag
where t3.id_comptag is null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_6_maj_auto_pt_non_linear_lin(annee=var('annee'), dept=var('dept'), sim_seuil_bas=0.2, dist_seuil_haut=20) %}

select 
    -- Colonnes de la vérification : récup de l'id_comptag de référence
    t2.id_comptag,
    -- Toutes les autres colonnes du modèle mdl3b_lin_upd_pt_linear_devenu_assoc_19
    t1.id,
    t1.id_ign,
    t1.nature,
    t1.nom_coll_g,
    t1.nom_coll_d,
    t1.numero,
    t1.importance,
    t1.cl_admin,
    t1.gestion,
    t1.fictif,
    t1.largeur,
    t1.nb_voies,
    t1.sens,
    t1.etat,
    t1.inseecom_g,
    t1.inseecom_d,
    t1.id_voie_g,
    t1.id_voie_d,
    t1.urbain,
    t1.vit_moy_vl,
    t1.restr_p,
    t1.dept,
    t1.dept_2024,
    t1.dept_2023,
    t1.long_km,
    'otv' src_cpt,
    'linearisation' coment_cpt,
    t1.ann_pt,
    t1.src_cpteur,
    t1.coment_tmj,
    t1.coment_tmj_f,
    t1.ann_pc_pl,
    t1.tmja,
    t1.pc_pl,
    t1.veh_km,
    t1.tmja_final,
    t1.pl,
    t1.pl_final,
    t1.pl_km,
    t1.id_cpt1,
    t1.id_cpt2,
    t1.obs_tmj1,
    t1.obs_tmj2,
    t1.tmja_cpt1,
    t1.tmja_cpt2,
    t1.codau_cat,
    t1.milieu,
    t1.codau,
    t1.type_vdf,
    t1.vts_vl_vdf,
    t1.vts_pl_vdf,
    t1.vts_gest,
    t1.id_vts,
    null obs_tmja,
    null obs_pc_pl,
    case when t1.obs_supl is not null then 'nouveau point traf{{annee}},ex '||t1.obs_supl
        else 'nouveau point traf{{annee}}' end obs_supl,
    t1.id_sect,
    t1.src_sect,
    t1.autor_sect,
    t1.obs_vts,
    t1.vts_osm,
    t1.vts_modif,
    t1.vts_vl_f,
    t1.vts_pl_f,
    t1.vts_type_vl,
    t1.vts_type_pl,
    t1.src_vma,
    t1.vma_vl,
    t1.vma_pl,
    t1.vma_type,
    t1.codau_cont,
    t1.id_codau_cont,
    t1.tmja_cont,
    t1.pc_pl_cont,
    t1."source",
    t1.target,
    t1.cnt_src,
    t1.cnt_tgt,
    t1.imp_sup,
    t1.imp_sup_src,
    t1.imp_sup_tgt,
    t1.recup,
    t1.id_cnt2,
    t1.id_struct_rout,
    t1.id_sect_hom,
    t1.id_simpli,
    t1.attr_modif,
    t1.id_bdc,
    t1.geom,
    t1.ang_orient_src_vert1,
    t1.ang_orient_tgt_vert1,
    t1.list_id_inter,
    t1.nb_nod_non_topo,
    t1.id_struct
from {{ref('cte1_mdl6_lin_upd_auto_pt_non_linear_' ~ dept ~ '__choix_cpt_tronc')}}  t2
join {{ref('mdl3b_lin_upd_pt_linear_devenu_assoc_'~dept)}} t1
    on t2.id_simpli = t1.id_simpli
where t1.coment_cpt = 'estimation' and t2.coment_cpt = 'estimation' 
        and t2.sim > {{sim_seuil_bas}} and t2.dist < {{dist_seuil_haut}}
UNION
-- Lignes de mdl3b_lin_upd_pt_linear_devenu_assoc_19 non présentes dans la maj
select 
    t1.id_comptag,
    t1.id,
    t1.id_ign,
    t1.nature,
    t1.nom_coll_g,
    t1.nom_coll_d,
    t1.numero,
    t1.importance,
    t1.cl_admin,
    t1.gestion,
    t1.fictif,
    t1.largeur,
    t1.nb_voies,
    t1.sens,
    t1.etat,
    t1.inseecom_g,
    t1.inseecom_d,
    t1.id_voie_g,
    t1.id_voie_d,
    t1.urbain,
    t1.vit_moy_vl,
    t1.restr_p,
    t1.dept,
    t1.dept_2024,
    t1.dept_2023,
    t1.long_km,
    t1.src_cpt,
    t1.coment_cpt,
    t1.ann_pt,
    t1.src_cpteur,
    t1.coment_tmj,
    t1.coment_tmj_f,
    t1.ann_pc_pl,
    t1.tmja,
    t1.pc_pl,
    t1.veh_km,
    t1.tmja_final,
    t1.pl,
    t1.pl_final,
    t1.pl_km,
    t1.id_cpt1,
    t1.id_cpt2,
    t1.obs_tmj1,
    t1.obs_tmj2,
    t1.tmja_cpt1,
    t1.tmja_cpt2,
    t1.codau_cat,
    t1.milieu,
    t1.codau,
    t1.type_vdf,
    t1.vts_vl_vdf,
    t1.vts_pl_vdf,
    t1.vts_gest,
    t1.id_vts,
    t1.obs_tmja,
    t1.obs_pc_pl,
    t1.obs_supl,
    t1.id_sect,
    t1.src_sect,
    t1.autor_sect,
    t1.obs_vts,
    t1.vts_osm,
    t1.vts_modif,
    t1.vts_vl_f,
    t1.vts_pl_f,
    t1.vts_type_vl,
    t1.vts_type_pl,
    t1.src_vma,
    t1.vma_vl,
    t1.vma_pl,
    t1.vma_type,
    t1.codau_cont,
    t1.id_codau_cont,
    t1.tmja_cont,
    t1.pc_pl_cont,
    t1."source",
    t1.target,
    t1.cnt_src,
    t1.cnt_tgt,
    t1.imp_sup,
    t1.imp_sup_src,
    t1.imp_sup_tgt,
    t1.recup,
    t1.id_cnt2,
    t1.id_struct_rout,
    t1.id_sect_hom,
    t1.id_simpli,
    t1.attr_modif,
    t1.id_bdc,
    t1.geom,
    t1.ang_orient_src_vert1,
    t1.ang_orient_tgt_vert1,
    t1.list_id_inter,
    t1.nb_nod_non_topo,
    t1.id_struct
from {{ref('mdl3b_lin_upd_pt_linear_devenu_assoc_'~dept)}} t1
where not exists (
    select 1 
    from {{ref('cte1_mdl6_lin_upd_auto_pt_non_linear_' ~ dept ~ '__choix_cpt_tronc')}} t2
    where (t2.id_simpli = t1.id_simpli) and (t1.coment_cpt = 'estimation' and t2.coment_cpt = 'estimation' 
        and t2.sim > 0.2 and t2.dist < 20))

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{%- macro cte1_mcr_6_maj_auto_pt_non_linear_lin__choix_cpt_tronc(annee=var('annee'), dept=var('dept')) %}

select distinct on (id_comptag) id_comptag,coment_cpt,id,id_ign,id_simpli,numero,nom_coll_g,importance,route,nature,sim,dist,rg
from ({{cte3_mcr_6_maj_auto_pt_non_linear_lin__rang(annee, dept)}}) t1 order by id_comptag,rg

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte2_mcr_6_maj_auto_pt_non_linear_lin__project_cpt(annee=var('annee'), dept=var('dept')) %}

select t1.id_comptag,t2.coment_cpt,t2.id,t2.id_ign,t2.id_simpli,t2.numero,t2.importance,t2.nature,t2.nom_coll_g,t1.route,
case when substr(split_part(t1.id_comptag,'-',2),1,1) in ('A','N','D')
--RRN ou RD a forcement un numero
and substr(split_part(t1.id_comptag,'-',2),2,2) ~ '^[0-9]+$'
and (substr(t1.id_comptag,1,2) = ANY(ARRAY{{ var('dept_na') + var('dept_limitrophes') }}))
and t2.numero is not null then similarity(t1.route,t2.numero)
when t2.numero is null and t2.nom_coll_g is not null then similarity(upper(t1.route),t2.nom_coll_g)
else null end as sim,
round(st_distance(t1.geom,t2.geom)::numeric,2) as dist
--,t2.imp_sup,t2.imp_sup_src,t2.imp_sup_tgt 
from {{source('cptg', 'compteur')}} t1 join {{ref('mdl5_lin_chk_pt_non_linear_' ~ dept)}} t3 using(id_comptag)
                                       join {{ref('mdl3b_lin_upd_pt_linear_devenu_assoc_' ~ dept)}} t2 on st_dwithin(t1.geom,t2.geom,50)
order by t1.id_comptag, dist ASC

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte3_mcr_6_maj_auto_pt_non_linear_lin__rang(annee=var('annee'), dept=var('dept')) %}

select id_comptag,coment_cpt,id,id_ign,id_simpli,numero,nom_coll_g,importance,route,nature,sim,dist,
case when (id_comptag like '%Entree%' or id_comptag like '%Sortie%') and nature='Bretelle'
then dense_rank()over(partition by id_comptag order by dist asc)
when (id_comptag like '%Entree%' or id_comptag like '%Sortie%') and nature <>'Bretelle'
then dense_rank()over(partition by id_comptag order by dist asc)
else dense_rank()over(partition by id_comptag order by coalesce(sim,null,0) desc,dist asc) end as rg
--,imp_sup,imp_sup_src,imp_sup_tgt
from ({{cte2_mcr_6_maj_auto_pt_non_linear_lin__project_cpt(annee, dept)}}) t1

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_23a_vue_lin_finale(dept=var('dept')) %}

select * from {{ref('mdl22_lin_upd_cmt_tmj_f_estim_' ~ var('dept'))}}

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_23b_stats_linear(models_src, annee=var('annee')) %}

select round(sum(long_km)::numeric,2)  as long_tot,
(select round(sum(long_km)::numeric,2)  from {{models_src}} where coment_cpt='linearisation') as long_lin,
--round(sum(veh_km)::numeric,2)  as veh_km_tot,
--(select round(sum(veh_km)::numeric,2) from {{models_src}} where coment_cpt='linearisation') as veh_km_lin,
(select round(sum(long_km)::numeric,2)  from {{models_src}} where src_cpt='otv' and ann_pt='{{annee}}') as long_lin_pt_ann_n,
(select round(sum(long_km)::numeric,2)  from {{models_src}} where src_cpt='otv' and ann_pt::int<{{annee}}) as long_lin_pt_inf_ann_n,
(select count(distinct id_comptag) from {{models_src}} where src_cpt='otv') as compteur_otv,
(select count(distinct id_comptag) from {{models_src}} where src_cpt='otv' and ann_pt='{{annee}}') as compteur_otv_pt_ann_n,
(select count(distinct id_comptag) from {{models_src}} where src_cpt='otv' and ann_pt::int<{{annee}}) as compteur_otv_pt_inf_ann_n,
(((select sum(long_km) from {{models_src}} where coment_cpt='linearisation')/sum(long_km))*100)::numeric(5,2) as prc_lin_tot,
(((select sum(long_km) from {{models_src}} where coment_cpt='linearisation' and ann_pt='{{annee}}')/sum(long_km))*100)::numeric(5,2) as prc_lin_ann_n,
(((select sum(long_km) from {{models_src}} where coment_cpt='linearisation' and ann_pt='{{annee}}')/
(select sum(long_km) from {{models_src}} where coment_cpt='linearisation'))*100)::numeric(5,2) as lin_ann_n_lin_tot
from {{models_src}}

{% endmacro %}
