{% macro mcr_13c_maj_cpt_hors_dept_dans_na_lin(dept=var('dept'), annee=var('annee')) %}


-- Lignes présentes dans la MaJ auto
with auto_maj as (
    {{ cte1_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__auto() }}
)
select 
    ut.id_comptag,
    ut.id_ign,
    ut.id_simpli,
    ut.id,
    ut.nature,
    ut.nom_coll_g,
    ut.nom_coll_d,
    ut.numero,
    ut.importance,
    ut.cl_admin,
    ut.gestion,
    ut.fictif,
    ut.largeur,
    ut.nb_voies,
    ut.sens,
    ut.etat,
    ut.inseecom_g,
    ut.inseecom_d,
    ut.id_voie_g,
    ut.id_voie_d,
    ut.urbain,
    ut.vit_moy_vl,
    ut.restr_p,
    ut.dept,
    ut.dept_2024,
    ut.dept_2023,
    ut.long_km,
    ut.src_cpt,
    ut.coment_cpt,
    a.annee_tmja as ann_pt,
    ut.src_cpteur,
    ut.coment_tmj,
    ut.coment_tmj_f,
    ut.ann_pc_pl,
    a.tmja,
    case when a.pc_pl is not null then a.pc_pl else ut.pc_pl end pc_pl,
    ut.veh_km,
    ut.tmja_final,
    case when a.pl is not null then a.pl else ut.pl end pl,
    ut.pl_final,
    ut.pl_km,
    ut.id_cpt1,
    ut.id_cpt2,
    ut.obs_tmj1,
    ut.obs_tmj2,
    ut.tmja_cpt1,
    ut.tmja_cpt2,
    ut.codau_cat,
    ut.milieu,
    ut.codau,
    ut.type_vdf,
    ut.vts_vl_vdf,
    ut.vts_pl_vdf,
    ut.vts_gest,
    ut.id_vts,
    ut.obs_tmja,
    ut.obs_pc_pl,
    ut.obs_supl,
    ut.id_sect,
    ut.src_sect,
    ut.autor_sect,
    ut.obs_vts,
    ut.vts_osm,
    ut.vts_modif,
    ut.vts_vl_f,
    ut.vts_pl_f,
    ut.vts_type_vl,
    ut.vts_type_pl,
    ut.src_vma,
    ut.vma_vl,
    ut.vma_pl,
    ut.vma_type,
    ut.codau_cont,
    ut.id_codau_cont,
    ut.tmja_cont,
    ut.pc_pl_cont,
    ut."source",
    ut.target,
    ut.cnt_src,
    ut.cnt_tgt,
    ut.imp_sup,
    ut.imp_sup_src,
    ut.imp_sup_tgt,
    ut.recup,
    ut.id_cnt2,
    ut.id_struct_rout,
    ut.id_sect_hom,
    ut.attr_modif,
    ut.id_bdc,
    ut.geom,
    ut.ang_orient_src_vert1,
    ut.ang_orient_tgt_vert1,
    ut.list_id_inter,
    ut.nb_nod_non_topo,
    ut.id_struct
from {{ ref('mdl12i_lin_upd_indic_traf_' ~ dept) }} ut
join auto_maj a
    on ut.id_comptag = a.id_comptag

UNION

-- données de comptage issu du seed de MaJ manuelle d'un comptage dans lin uniquement
select 
    ut.id_comptag,
    ut.id_ign,
    ut.id_simpli,
    ut.id,
    ut.nature,
    ut.nom_coll_g,
    ut.nom_coll_d,
    ut.numero,
    ut.importance,
    ut.cl_admin,
    ut.gestion,
    ut.fictif,
    ut.largeur,
    ut.nb_voies,
    ut.sens,
    ut.etat,
    ut.inseecom_g,
    ut.inseecom_d,
    ut.id_voie_g,
    ut.id_voie_d,
    ut.urbain,
    ut.vit_moy_vl,
    ut.restr_p,
    ut.dept,
    ut.dept_2024,
    ut.dept_2023,
    ut.long_km,
    ut.src_cpt,
    ut.coment_cpt,
    '{{annee}}' as ann_pt,
    ut.src_cpteur,
    ut.coment_tmj,
    ut.coment_tmj_f,
    ut.ann_pc_pl,
    em.tmja,
    case when em.pc_pl is not null then em.pc_pl else ut.pc_pl end pc_pl,
    ut.veh_km,
    ut.tmja_final,
    case when em.pc_pl is not null then em.tmja*em.pc_pl/100 else ut.pl end pl,
    ut.pl_final,
    ut.pl_km,
    ut.id_cpt1,
    ut.id_cpt2,
    ut.obs_tmj1,
    ut.obs_tmj2,
    ut.tmja_cpt1,
    ut.tmja_cpt2,
    ut.codau_cat,
    ut.milieu,
    ut.codau,
    ut.type_vdf,
    ut.vts_vl_vdf,
    ut.vts_pl_vdf,
    ut.vts_gest,
    ut.id_vts,
    ut.obs_tmja,
    ut.obs_pc_pl,
    ut.obs_supl,
    ut.id_sect,
    ut.src_sect,
    ut.autor_sect,
    ut.obs_vts,
    ut.vts_osm,
    ut.vts_modif,
    ut.vts_vl_f,
    ut.vts_pl_f,
    ut.vts_type_vl,
    ut.vts_type_pl,
    ut.src_vma,
    ut.vma_vl,
    ut.vma_pl,
    ut.vma_type,
    ut.codau_cont,
    ut.id_codau_cont,
    ut.tmja_cont,
    ut.pc_pl_cont,
    ut."source",
    ut.target,
    ut.cnt_src,
    ut.cnt_tgt,
    ut.imp_sup,
    ut.imp_sup_src,
    ut.imp_sup_tgt,
    ut.recup,
    ut.id_cnt2,
    ut.id_struct_rout,
    ut.id_sect_hom,
    ut.attr_modif,
    ut.id_bdc,
    ut.geom,
    ut.ang_orient_src_vert1,
    ut.ang_orient_tgt_vert1,
    ut.list_id_inter,
    ut.nb_nod_non_topo,
    ut.id_struct
from {{ ref('mdl12i_lin_upd_indic_traf_' ~ dept) }} ut
join {{ ref('sed13c_dept' ~ dept ~ '_upd_cpt_existant_mano') }} em
    on ut.id_comptag = em.id_comptag

UNION

-- le reste des ligne inchangées
select 
    ut.id_comptag,
    ut.id_ign,
    ut.id_simpli,
    ut.id,
    ut.nature,
    ut.nom_coll_g,
    ut.nom_coll_d,
    ut.numero,
    ut.importance,
    ut.cl_admin,
    ut.gestion,
    ut.fictif,
    ut.largeur,
    ut.nb_voies,
    ut.sens,
    ut.etat,
    ut.inseecom_g,
    ut.inseecom_d,
    ut.id_voie_g,
    ut.id_voie_d,
    ut.urbain,
    ut.vit_moy_vl,
    ut.restr_p,
    ut.dept,
    ut.dept_2024,
    ut.dept_2023,
    ut.long_km,
    ut.src_cpt,
    ut.coment_cpt,
    ut.ann_pt,
    ut.src_cpteur,
    ut.coment_tmj,
    ut.coment_tmj_f,
    ut.ann_pc_pl,
    ut.tmja,
    ut.pc_pl,
    ut.veh_km,
    ut.tmja_final,
    ut.pl,
    ut.pl_final,
    ut.pl_km,
    ut.id_cpt1,
    ut.id_cpt2,
    ut.obs_tmj1,
    ut.obs_tmj2,
    ut.tmja_cpt1,
    ut.tmja_cpt2,
    ut.codau_cat,
    ut.milieu,
    ut.codau,
    ut.type_vdf,
    ut.vts_vl_vdf,
    ut.vts_pl_vdf,
    ut.vts_gest,
    ut.id_vts,
    ut.obs_tmja,
    ut.obs_pc_pl,
    ut.obs_supl,
    ut.id_sect,
    ut.src_sect,
    ut.autor_sect,
    ut.obs_vts,
    ut.vts_osm,
    ut.vts_modif,
    ut.vts_vl_f,
    ut.vts_pl_f,
    ut.vts_type_vl,
    ut.vts_type_pl,
    ut.src_vma,
    ut.vma_vl,
    ut.vma_pl,
    ut.vma_type,
    ut.codau_cont,
    ut.id_codau_cont,
    ut.tmja_cont,
    ut.pc_pl_cont,
    ut."source",
    ut.target,
    ut.cnt_src,
    ut.cnt_tgt,
    ut.imp_sup,
    ut.imp_sup_src,
    ut.imp_sup_tgt,
    ut.recup,
    ut.id_cnt2,
    ut.id_struct_rout,
    ut.id_sect_hom,
    ut.attr_modif,
    ut.id_bdc,
    ut.geom,
    ut.ang_orient_src_vert1,
    ut.ang_orient_tgt_vert1,
    ut.list_id_inter,
    ut.nb_nod_non_topo,
    ut.id_struct
from {{ ref('mdl12i_lin_upd_indic_traf_' ~ dept) }} ut
where not exists (
    select 1
    from auto_maj a
    where ut.id_comptag = a.id_comptag
)and not exists (
    select 1
    from {{ ref('sed13c_dept' ~ dept ~ '_upd_cpt_existant_mano') }} em
    where ut.id_comptag = em.id_comptag
)

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte1_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__auto(annee=var('annee')) %}

select c.id_comptag, v.tmja, v.annee_tmja, v.pc_pl, 
       case when v.pc_pl is not null then v.pc_pl*v.tmja/100 else null end as pl
 from ({{cte2_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__list_cpt()}}) c 
    join {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} v using (id_comptag)
 where v.annee_tmja = '{{annee}}' 
    
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte2_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__list_cpt(dept=var('dept')) %}

select distinct l.id_comptag, c.type_poste
 from {{ref('mdl12i_lin_upd_indic_traf_' ~ dept)}} l
      join {{source('cptg', 'compteur')}} c using (id_comptag),
      lateral (select split_part(l.id_comptag,'-',1) as depart) d
 where l.id_comptag is not null and d.depart = any(array{{var('dept_na')}}) and d.depart != '{{dept}}'
    
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

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

{# ─────────────────────────────────────────────────────────── #}

{% macro cte1_mcr_13d_vrf_histo_traf_lin(annee=var('annee')) -%}

{% set annees_list = range(annee, 1999, -1) | list + [1900] %}
{% set BdxMet_annees_list = range(2020, (annee|int) + 1, 1) %}

SELECT row_number() OVER () AS gid,
    t1.id_comptag,
    t2.gestionnai,
    t2.route,
    t2.type_poste,
    t2.convention,
    t2.sens_cpt,
    {% for ann in annees_list %}
    t1.tmja_{{ ann }},
    t1.pc_pl_{{ ann }},
    t1.src_{{ ann }},
    t1.obs_{{ ann }},
    t1.periode_{{ ann }},
    {% endfor %}
    t2.geom
   FROM ( SELECT s1.id_comptag,
            {% for ann in annees_list %}
            max(s2.valeur::numeric) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS tmja_{{ ann }},
            max(s2.valeur::numeric) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'pc_pl'::text) AS pc_pl_{{ ann }},
            max(s1.src) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS src_{{ ann }},
            max(s1.obs) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS obs_{{ ann }},
            max(s1.periode::text) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS periode_{{ ann }}{{ "," if not loop.last }}
            {% endfor %}
            FROM {{ source('cptg', 'comptage') }} s1
             JOIN ( SELECT ss1.id_comptag_uniq,
                        CASE
                            WHEN ss2.id_comptag::text ~~ 'BdxMet-%'::text AND (ss2.annee::bpchar = ANY (ARRAY[{% for ann in BdxMet_annees_list %}'{{ ann }}'::bpchar{% if not loop.last %},{% endif %}{% endfor %}])) AND ss1.indicateur::text = 'tmjo'::text THEN 'tmja'::character varying
                            WHEN ss2.id_comptag::text ~~ 'BdxMet-%'::text AND (ss2.annee::bpchar = ANY (ARRAY[{% for ann in BdxMet_annees_list %}'{{ ann }}'::bpchar{% if not loop.last %},{% endif %}{% endfor %}])) AND ss1.indicateur::text = 'pc_pl_o'::text THEN 'pc_pl'::character varying
                            WHEN ss2.id_comptag::text = 'Soyaux-rue_de_l_isle-d_e.-0.2051;45.6479'::text AND ss1.indicateur::text = 'tmjo'::text THEN 'tmja'::character varying
                            ELSE ss1.indicateur
                        END AS indicateur,
                    ss1.valeur
                   FROM {{ source('cptg', 'indic_agrege') }} ss1
                     JOIN  {{ source('cptg', 'comptage') }} ss2 ON ss1.id_comptag_uniq = ss2.id) s2 ON s1.id = s2.id_comptag_uniq
          WHERE (s2.indicateur::text = ANY (ARRAY['tmja'::character varying::text, 'pc_pl'::character varying::text])) AND (s1.annee::bpchar = ANY (ARRAY[{% for ann in annees_list %}'{{ ann }}'::bpchar{% if not loop.last %},{% endif %}{% endfor %}]))
          GROUP BY s1.id_comptag
          ORDER BY s1.id_comptag) t1
     JOIN {{ source('cptg', 'compteur') }} t2 ON t1.id_comptag::text = t2.id_comptag::text
  ORDER BY t1.id_comptag

{%- endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_13e_vrf_split_id_cptg_lin(modele, part=1, separator='-') %}

select distinct split_part(id_comptag, '{{ separator }}', {{ part }}) 
from {{ ref(modele) }} 
where id_comptag is not null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14e_maj_cmt_tmj_f_itself_lin(dept=var('dept')) %}

-- Mise à jour des coment_tmj_f à partir de coment_tmj_f_initial
-- pour les lignes dont le coment_tmj_f a été modifié dans le seed
select 
lin.id_comptag,
lin.id_ign,
lin.id_simpli,
lin.id,
lin.nature,
lin.nom_coll_g,
lin.nom_coll_d,
lin.numero,
lin.importance,
lin.cl_admin,
lin.gestion,
lin.fictif,
lin.largeur,
lin.nb_voies,
lin.sens,
lin.etat,
lin.inseecom_g,
lin.inseecom_d,
lin.id_voie_g,
lin.id_voie_d,
lin.urbain,
lin.vit_moy_vl,
lin.restr_p,
lin.dept,
lin.dept_2024,
lin.dept_2023,
lin.long_km,
lin.src_cpt,
lin.coment_cpt,
lin.ann_pt,
lin.src_cpteur,
ctf.coment_tmj_f_updated as coment_tmj,
ctf.coment_tmj_f_updated as coment_tmj_f,
lin.ann_pc_pl,
lin.tmja,
lin.pc_pl,
lin.veh_km,
lin.tmja_final,
lin.pl,
lin.pl_final,
lin.pl_km,
lin.id_cpt1,
lin.id_cpt2,
lin.obs_tmj1,
lin.obs_tmj2,
lin.tmja_cpt1,
lin.tmja_cpt2,
lin.codau_cat,
lin.milieu,
lin.codau,
lin.type_vdf,
lin.vts_vl_vdf,
lin.vts_pl_vdf,
lin.vts_gest,
lin.id_vts,
lin.obs_tmja,
lin.obs_pc_pl ,
lin.obs_supl,
lin.id_sect,
lin.src_sect,
lin.autor_sect,
lin.obs_vts,
lin.vts_osm,
lin.vts_modif,
lin.vts_vl_f,
lin.vts_pl_f,
lin.vts_type_vl,
lin.vts_type_pl,
lin.src_vma,
lin.vma_vl,
lin.vma_pl,
lin.vma_type,
lin.codau_cont,
lin.id_codau_cont,
lin.tmja_cont,
lin.pc_pl_cont,
lin."source",
lin."target",
lin.cnt_src,
lin.cnt_tgt,
lin.imp_sup,
lin.imp_sup_src,
lin.imp_sup_tgt,
lin.recup,
lin.id_cnt2,
lin.id_struct_rout,
lin.id_sect_hom,
lin.attr_modif,
lin.id_bdc,
lin.geom,
lin.ang_orient_src_vert1,
lin.ang_orient_tgt_vert1,
lin.list_id_inter,
lin.nb_nod_non_topo,
lin.id_struct
from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} lin
join {{ref('sed14e_dept' ~ dept ~ '_upd_cmt_tmj_f_with_cmt_tmj_f')}} ctf
    on lin.coment_tmj_f=ctf.coment_tmj_f_initial
union
-- reprise des lignes dont le coment_tmj_f n'a pas été modifié dans le seed
select 
lin.id_comptag,
lin.id_ign,
lin.id_simpli,
lin.id,
lin.nature,
lin.nom_coll_g,
lin.nom_coll_d,
lin.numero,
lin.importance,
lin.cl_admin,
lin.gestion,
lin.fictif,
lin.largeur,
lin.nb_voies,
lin.sens,
lin.etat,
lin.inseecom_g,
lin.inseecom_d,
lin.id_voie_g,
lin.id_voie_d,
lin.urbain,
lin.vit_moy_vl,
lin.restr_p,
lin.dept,
lin.dept_2024,
lin.dept_2023,
lin.long_km,
lin.src_cpt,
lin.coment_cpt,
lin.ann_pt,
lin.src_cpteur,
lin.coment_tmj,
lin.coment_tmj_f,
lin.ann_pc_pl,
lin.tmja,
lin.pc_pl,
lin.veh_km,
lin.tmja_final,
lin.pl,
lin.pl_final,
lin.pl_km,
lin.id_cpt1,
lin.id_cpt2,
lin.obs_tmj1,
lin.obs_tmj2,
lin.tmja_cpt1,
lin.tmja_cpt2,
lin.codau_cat,
lin.milieu,
lin.codau,
lin.type_vdf,
lin.vts_vl_vdf,
lin.vts_pl_vdf,
lin.vts_gest,
lin.id_vts,
lin.obs_tmja,
lin.obs_pc_pl ,
lin.obs_supl,
lin.id_sect,
lin.src_sect,
lin.autor_sect,
lin.obs_vts,
lin.vts_osm,
lin.vts_modif,
lin.vts_vl_f,
lin.vts_pl_f,
lin.vts_type_vl,
lin.vts_type_pl,
lin.src_vma,
lin.vma_vl,
lin.vma_pl,
lin.vma_type,
lin.codau_cont,
lin.id_codau_cont,
lin.tmja_cont,
lin.pc_pl_cont,
lin."source",
lin."target",
lin.cnt_src,
lin.cnt_tgt,
lin.imp_sup,
lin.imp_sup_src,
lin.imp_sup_tgt,
lin.recup,
lin.id_cnt2,
lin.id_struct_rout,
lin.id_sect_hom,
lin.attr_modif,
lin.id_bdc,
lin.geom,
lin.ang_orient_src_vert1,
lin.ang_orient_tgt_vert1,
lin.list_id_inter,
lin.nb_nod_non_topo,
lin.id_struct
from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} lin
where not exists (
    select 1
    from {{ref('sed14e_dept' ~ dept ~ '_upd_cmt_tmj_f_with_cmt_tmj_f')}} ctf
    where lin.coment_tmj_f=ctf.coment_tmj_f_initial
)

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14f_vrf_annee_rrn_pas_dispo(dept=var('dept'), annee=var('annee')) %}

select distinct id_comptag,ann_pt,tmja,ann_pc_pl,pc_pl 
from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} 
where ann_pt::int<{{ annee }} and (id_comptag like '%-N%' or id_comptag like '%-A%')

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14g_vrf_coher_cptg_std_vs_linear_lin(dept=var('dept'), dist=10) %}

select distinct on (t1.id_comptag) t1.id_comptag id_comptag_standardise,t2.id_comptag id_comptag_linearise,
                   st_distance(t1.geom,t2.geom) as dist,t1.geom
--t1.type_poste,t1.sens_cpt,t1.geom
from ({{cte1_mcr_14g_vrf_coher_cpt_std_lin__cpt_lin(dept)}})  t1
join
(select id_comptag,ann_pt,tmja,obs_supl,geom from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} where id_comptag is not null) t2
on st_dwithin(t1.geom,t2.geom,{{ dist }})
where t1.id_comptag<>t2.id_comptag
order by t1.id_comptag,st_distance(t1.geom,t2.geom) asc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte1_mcr_14g_vrf_coher_cpt_std_lin__cpt_lin(dept=var('dept')) %}

select t1.id_comptag,t1.type_poste,t1.sens_cpt,t1.geom 
  from {{source('cptg', 'compteur')}} t1
join (select distinct id_comptag from  {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}}  where id_comptag is not null) t2
using (id_comptag)

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14h_vrf_cmt_tmj_f_reseau_ratio_lin(dept=var('dept')) %}

select distinct left(split_part(id_comptag,'-',2),1) as reseau,
                split_part(coment_tmj_f,'/',2)::int as ratio
from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}}
where src_cpt='otv' and split_part(id_comptag,'-',1)  ~ '^[0-9]+$' 
      and coment_tmj_f like '/%'
order by reseau,ratio

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14j_vrf_stats_importance_nature_estim_lin(dept=var('dept')) %}

WITH all_combinations AS (
    SELECT DISTINCT importance, nature
    FROM {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}}
    WHERE importance = ANY(ARRAY[{{var('importance_verif')}}])
),
stats AS (
    SELECT 
        importance,
        nature,
        count(*) as cnt,
        round(sum(long_km::numeric),2) as sum_lg_km,
        array_agg(distinct coalesce(numero,'null')) as list_num
    FROM {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} 
    WHERE coment_cpt='estimation'
    GROUP BY importance, nature
)
SELECT 
    ac.importance,
    ac.nature,
    COALESCE(s.cnt, 0) as cnt,
    COALESCE(s.sum_lg_km, 0) as sum_lg_km,
    s.list_num::text[]
FROM all_combinations ac
LEFT JOIN stats s ON ac.importance = s.importance AND ac.nature = s.nature
ORDER BY ac.importance, ac.nature

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_xx_maj_cmt_tmj_f_with_ids(model_src, dept=var('dept')) %}

-- Lignes présentes dans le seed (avec jointure)
select 
    -- Colonnes du seed
    ctf.id_comptag,
    ctf.id_ign,
    ctf.id_simpli,
    
    -- Toutes les autres colonnes du modèle
    ctf.id,
    ctf.nature,
    ctf.nom_coll_g,
    ctf.nom_coll_d,
    ctf.numero,
    ctf.importance,
    ctf.cl_admin,
    ctf.gestion,
    ctf.fictif,
    ctf.largeur,
    ctf.nb_voies,
    ctf.sens,
    ctf.etat,
    ctf.inseecom_g,
    ctf.inseecom_d,
    ctf.id_voie_g,
    ctf.id_voie_d,
    ctf.urbain,
    ctf.vit_moy_vl,
    ctf.restr_p,
    ctf.dept,
    ctf.dept_2024,
    ctf.dept_2023,
    ctf.long_km,
    ctf.src_cpt,
    ctf.coment_cpt,
    ctf.ann_pt,
    ctf.src_cpteur,
    uci.coment_tmj_f as coment_tmj,
    uci.coment_tmj_f,
    ctf.ann_pc_pl,
    ctf.tmja,
    ctf.pc_pl,
    ctf.veh_km,
    ctf.tmja_final,
    ctf.pl,
    ctf.pl_final,
    ctf.pl_km,
    ctf.id_cpt1,
    ctf.id_cpt2,
    ctf.obs_tmj1,
    ctf.obs_tmj2,
    ctf.tmja_cpt1,
    ctf.tmja_cpt2,
    ctf.codau_cat,
    ctf.milieu,
    ctf.codau,
    ctf.type_vdf,
    ctf.vts_vl_vdf,
    ctf.vts_pl_vdf,
    ctf.vts_gest,
    ctf.id_vts,
    ctf.obs_tmja,
    ctf.obs_pc_pl,
    ctf.obs_supl,
    ctf.id_sect,
    ctf.src_sect,
    ctf.autor_sect,
    ctf.obs_vts,
    ctf.vts_osm,
    ctf.vts_modif,
    ctf.vts_vl_f,
    ctf.vts_pl_f,
    ctf.vts_type_vl,
    ctf.vts_type_pl,
    ctf.src_vma,
    ctf.vma_vl,
    ctf.vma_pl,
    ctf.vma_type,
    ctf.codau_cont,
    ctf.id_codau_cont,
    ctf.tmja_cont,
    ctf.pc_pl_cont,
    ctf."source",
    ctf.target,
    ctf.cnt_src,
    ctf.cnt_tgt,
    ctf.imp_sup,
    ctf.imp_sup_src,
    ctf.imp_sup_tgt,
    ctf.recup,
    ctf.id_cnt2,
    ctf.id_struct_rout,
    ctf.id_sect_hom,
    ctf.attr_modif,
    ctf.id_bdc,
    ctf.geom,
    ctf.ang_orient_src_vert1,
    ctf.ang_orient_tgt_vert1,
    ctf.list_id_inter,
    ctf.nb_nod_non_topo,
    ctf.id_struct
from {{ ref('sed15a_dept' ~ dept ~ '_upd_cmt_tmj_f_with_ids') }} uci
join {{ model_src }} ctf
    on (array[ctf.id_ign]::text[] && uci.id_ign) or (ctf.id_simpli && uci.id_simpli)

UNION

-- Lignes de mdl1_creer_vue_19 non présentes dans le seed
select 
    ctf.id_comptag,
    ctf.id_ign,
    ctf.id_simpli,
    
    -- Toutes les autres colonnes du modèle
    ctf.id,
    ctf.nature,
    ctf.nom_coll_g,
    ctf.nom_coll_d,
    ctf.numero,
    ctf.importance,
    ctf.cl_admin,
    ctf.gestion,
    ctf.fictif,
    ctf.largeur,
    ctf.nb_voies,
    ctf.sens,
    ctf.etat,
    ctf.inseecom_g,
    ctf.inseecom_d,
    ctf.id_voie_g,
    ctf.id_voie_d,
    ctf.urbain,
    ctf.vit_moy_vl,
    ctf.restr_p,
    ctf.dept,
    ctf.dept_2024,
    ctf.dept_2023,
    ctf.long_km,
    ctf.src_cpt,
    ctf.coment_cpt,
    ctf.ann_pt,
    ctf.src_cpteur,
    ctf.coment_tmj,
    ctf.coment_tmj_f,
    ctf.ann_pc_pl,
    ctf.tmja,
    ctf.pc_pl,
    ctf.veh_km,
    ctf.tmja_final,
    ctf.pl,
    ctf.pl_final,
    ctf.pl_km,
    ctf.id_cpt1,
    ctf.id_cpt2,
    ctf.obs_tmj1,
    ctf.obs_tmj2,
    ctf.tmja_cpt1,
    ctf.tmja_cpt2,
    ctf.codau_cat,
    ctf.milieu,
    ctf.codau,
    ctf.type_vdf,
    ctf.vts_vl_vdf,
    ctf.vts_pl_vdf,
    ctf.vts_gest,
    ctf.id_vts,
    ctf.obs_tmja,
    ctf.obs_pc_pl,
    ctf.obs_supl,
    ctf.id_sect,
    ctf.src_sect,
    ctf.autor_sect,
    ctf.obs_vts,
    ctf.vts_osm,
    ctf.vts_modif,
    ctf.vts_vl_f,
    ctf.vts_pl_f,
    ctf.vts_type_vl,
    ctf.vts_type_pl,
    ctf.src_vma,
    ctf.vma_vl,
    ctf.vma_pl,
    ctf.vma_type,
    ctf.codau_cont,
    ctf.id_codau_cont,
    ctf.tmja_cont,
    ctf.pc_pl_cont,
    ctf."source",
    ctf.target,
    ctf.cnt_src,
    ctf.cnt_tgt,
    ctf.imp_sup,
    ctf.imp_sup_src,
    ctf.imp_sup_tgt,
    ctf.recup,
    ctf.id_cnt2,
    ctf.id_struct_rout,
    ctf.id_sect_hom,
    ctf.attr_modif,
    ctf.id_bdc,
    ctf.geom,
    ctf.ang_orient_src_vert1,
    ctf.ang_orient_tgt_vert1,
    ctf.list_id_inter,
    ctf.nb_nod_non_topo,
    ctf.id_struct
from {{ model_src }} ctf
where not exists (
    select 1 
    from {{ ref('sed15a_dept' ~ dept ~ '_upd_cmt_tmj_f_with_ids') }} uci
    where (array[ctf.id_ign]::text[] && uci.id_ign) or (ctf.id_simpli && uci.id_simpli)
)

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_15b_vrf_cmt_tmj_f_attr_modif(dept=var('dept')) %}

select id_ign,id_comptag,nature,numero,importance 
from {{ref('mdl14e_lin_upd_cmt_tmj_f_lui_mm_' ~ dept)}} 
where left(split_part(id_comptag,'-',2),1) in ('A','N') and attr_modif is not null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_15c_vrf_cmt_tmj_f_recup(dept=var('dept')) %}

select id_ign,id_comptag,coalesce(numero,'NULL') as numero,
       nature,importance,sens,coment_tmj_f,recup 
from  {{ref('mdl14e_lin_upd_cmt_tmj_f_lui_mm_' ~ dept)}}
where left(split_part(id_comptag,'-',2),1) in ('A','N') 
    and recup not in ('pk_ign','ad')

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_15d_vrf_numero_rrn_lin(dept=var('dept')) %}

select distinct numero 
 from {{ ref('mdl14e_lin_upd_cmt_tmj_f_lui_mm_' ~ dept)}} 
 where cl_admin = ANY(ARRAY{{var('cl_admin_rrn_verif')}})

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_15e_vrf_val_aberr_tmja(dept=var('dept'), 
    seuil_evol=var('seuil_evol_tmja_verif'),
    seuil_diff=var('seuil_diff_tmja_verif'), 
    ann_n_filter=var('annee'), 
    ann_n_1_filter=none, 
    id_comptag_like=none,
    percentile_value=none) %}

SELECT {% if not percentile_value %} * {% else %} PERCENTILE_DISC({{percentile_value}}) WITHIN GROUP(ORDER BY t.evol_n_n_1) as percentile_value {% endif %}
FROM ({{ cte2_mcr_15e_vrf_val_aberr_tmja__evo_ann_n_n_1(dept=dept) }}) t
where abs(t.evol_n_n_1) > {{seuil_evol}} and abs(t.diff_n_n_1) > {{seuil_diff}} and t.annee_n = '{{ann_n_filter}}'
{% if id_comptag_like %} and t.id_comptag like '{{id_comptag_like}}' {% endif %}
{% if ann_n_1_filter %} and t.annee_n_1='{{ann_n_1_filter}}' {% endif %}

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

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

{# ─────────────────────────────────────────────────────────── #}

{% macro cte2_mcr_15e_vrf_val_aberr_tmja__evo_ann_n_n_1(dept=var('dept')) %}

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
  from ({{ cte1_mcr_15e_vrf_val_aberr_tmja__ann_n_n_1(dept) }}) t1
  left join (select id_comptag,count(*) as nb_ann 
               from ({{ cte1_mcr_15e_vrf_val_aberr_tmja__ann_n_n_1(dept) }}) 
               group by id_comptag) t2 
    on t1.id_comptag=t2.id_comptag
  left join {{ source('cptg', 'comptage') }} t3
    on t1.id_comptag=t3.id_comptag and t1.annee_n=t3.annee
  where t1.tmja_n_1 is not null
  order by t1.id_comptag,t1.annee_n::int desc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_16b_vrf_periode_lin(dept=var('dept')) %}

select t1.id_comptag,t1.type_poste,t1.periode
from (select * from {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} 
      where id_comptag like '{{dept}}-D%'
      {% for agglo in var('agglo_' ~ dept) %}
        or id_comptag like '{{agglo}}-%'
      {% endfor %}
     ) t1
join (select distinct id_comptag from {{ ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept) }} 
      where id_comptag like '{{dept}}-D%'
      {% for agglo in var('agglo_' ~ dept) %}
        or id_comptag like '{{agglo}}-%'
      {% endfor %}
     ) t2
on t1.id_comptag=t2.id_comptag
where t1.type_poste in ('ponctuel', 'tournant' )
and (t1.periode like '%/07/%' or t1.periode like '%/08/%')

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

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

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_16e_vrf_evo_cpt_dev_assoc_lin(dept=var('dept'), annee=var('annee')) %}

select t1.id_cpteur_asso,t1.ann_pt as ann_lin_n_1,t1.tmja as tmja_lin_n_1,t1.type_poste as typ_post_lin_n_1,
t1.id_cpteur_ref,t2.ann_pt as ann_lin_n,t2.tmja as tmja_lin_n,t3.type_poste as typ_post_lin_n,
round(t2.tmja-t1.tmja) as diff_n_n_1,
round(((t2.tmja-t1.tmja)::numeric/t1.tmja::numeric)*100.0,2)as evol_n_n_1
from ({{cte1_mcr_16e_vrf_evo_cpt_dev_assoc__pt_ann_n_asso(dept, annee)}}) t1
join (select distinct id_comptag,ann_pt,tmja from {{ ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept) }} where id_comptag is not null) t2
on t1.id_cpteur_ref=t2.id_comptag
join {{source('cptg', 'compteur')}} t3 on t1.id_cpteur_ref=t3.id_comptag

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte1_mcr_16e_vrf_evo_cpt_dev_assoc__pt_ann_n_asso(dept=var('dept'), annee=var('annee')) %}

select * 
  from (select id_comptag, ann_pt, tmja from {{ref('cte4_mdl16e_lin_chk_evo_cpt_dev_assoc_19__pt_ann_n')}}) t3
    join (select id_cpteur_asso, type_poste, id_cpteur_ref
          from {{source('cptg_assoc', 'compteur')}}) t4 on t3.id_comptag = t4.id_cpteur_asso

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte2_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n(dept=var('dept')) %}


select distinct id_comptag from {{ ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept) }} where id_comptag is not null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{%macro cte3_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n_1(dept=var('dept'), annee=var('annee')) %}
{% set annee_n_1 = (annee | int - 1) | string %}

select distinct id_comptag, ann_pt, tmja from {{ source('traf', 'traf'~annee_n_1~'_bdt_na_ed'~annee_n_1[-2:]~'_l') }} where dept='{{dept}}' and id_comptag is not null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte4_mcr_16e_vrf_evo_cpt_dev_assoc__pt_ann_n(dept=var('dept'), annee=var('annee')) %}
{% set annee_n_1 = (annee | int - 1) | string %}

select t1.* -- t1.id_comptag, t1.ann_pt as ann_lin_n_1, t1.tmja as tmja_lin_n_1
from ({{cte3_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n_1(dept=dept, annee=annee)}}) as t1
  left join ({{cte2_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n(dept=dept)}}) as t2
on t1.id_comptag = t2.id_comptag
where t2.id_comptag is null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_16f_vrf_sens_agglo_lin(dept=var('dept'), annee=var('annee')) %}
{% set ann_n_1 = (annee | int - 1) | string %}

select s.id_ign,s.dept,s.src_cpt,s.id_comptag,s.sens_ed_n,s.sens_ed_n_1,s.recup,
s.coment_tmj_f_ed_n,s.coment_tmj_f_ed_n_1,
s.nature_n,s.nature_n_1
from (
select s1.dept,s1.src_cpt,s1.id,s1.id_ign,s1.id_comptag,s1.recup,
case when s1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then 'Sens unique' else s1.sens end as sens_ed_n,
case when s3.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then 'Sens unique' else s3.sens end as sens_ed_n_1,
case when s1.sens='{{var("bdtopo_double_sens_verif")}}' and s3.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then true
when s1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and s3.sens='{{var("bdtopo_double_sens_verif")}}' then true
else null end as modif_sens,
s1.coment_tmj_f as coment_tmj_f_ed_n,s3.coment_tmj_f as coment_tmj_f_ed_n_1,
s1.nature as nature_n,s3.nature as nature_n_1
from {{ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept)}} s1 join 
(select ss.id ,ss.id_ign,ss.id_propa,null as pk_ign,ss.ad,ss.imp,ss.topo_n,ss.recurs
from (select distinct on (id_ign) id,id_ign,id_propa,ad,imp,topo_n,recurs from ref.bdt_na_{{ann_n_1}}_{{annee}}_l
where sup is null and id_propa is not null and pk_ign is null order by id_ign, topo_n asc,imp asc,recurs asc) ss) s2
on s1.id_ign=s2.id_ign
join {{source('traf', 'traf' ~ ann_n_1 ~ '_bdt_na_ed' ~ ann_n_1[-2:] ~ '_l')}} s3 on s2.id_propa=s3.id_ign
)s
where s.modif_sens is true and s.recup not in ('ad','pk_ign') and s.src_cpt in ('otv')
and (
  {%- for agglo in var('agglo_19') %}
  s.id_comptag like '{{ agglo }}-%'
  {%- if not loop.last %} or {% endif %}
  {%- endfor %}
)

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_16g_vrf_sens_bret_rrn_lin(dept=var('dept')) %}

select s.id_ign, s.id_comptag, s.sens, s.sens_cpt, s.coment_tmj_f, s.verif_coment_tmj_f, s.obs_supl
from (
select t1.id_ign,t1.id_comptag,t1.sens,t2.sens_cpt,t1.coment_tmj_f,
case when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f='*2' then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}'  and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f,t1.obs_supl
--t1.obs_tmj1,t1.obs_tmj2,
from {{ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept)}} t1
join {{source('cptg', 'compteur')}} t2 using(id_comptag)
where t1.id_comptag ~ '((E|n)tree|(S|s)ortie)'
order by t1.id_comptag,t1.id_ign
) s
where s.verif_coment_tmj_f is false

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_xx_vrf_cmt_tmj_f_val_lin(model_src) %}

select distinct coment_tmj_f 
  from {{model_src}} 
  where src_cpt='otv'
  order by coment_tmj_f

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_xx_vrf_cptg_sens_unique_lin(model_src, dept=var('dept')) %}

select t1.id_comptag from 
    (select distinct id_comptag 
        from {{ model_src }} where id_comptag is not null) t1
    join {{source('cptg', 'compteur')}} t2 using(id_comptag)
    where t2.sens_cpt='{{ var("cptg_sens_uniq_verif") }}'

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_17a_maj_cmt_tmj_f_sens_lin(dept=var('dept')) %}

select 
    ctf.id_comptag,
    ctf.id_ign,
    ctf.id_simpli,
    ctf.id,
    ctf.nature,
    ctf.nom_coll_g,
    ctf.nom_coll_d,
    ctf.numero,
    ctf.importance,
    ctf.cl_admin,
    ctf.gestion,
    ctf.fictif,
    ctf.largeur,
    ctf.nb_voies,
    ctf.sens,
    ctf.etat,
    ctf.inseecom_g,
    ctf.inseecom_d,
    ctf.id_voie_g,
    ctf.id_voie_d,
    ctf.urbain,
    ctf.vit_moy_vl,
    ctf.restr_p,
    ctf.dept,
    ctf.dept_2024,
    ctf.dept_2023,
    ctf.long_km,
    ctf.src_cpt,
    ctf.coment_cpt,
    ctf.ann_pt,
    ctf.src_cpteur,
    ctf.coment_tmj,
    case when ctf.coment_tmj_f is null and ctf.sens in ('Sens direct','Sens inverse') and uci.type_correction='null -> divise par 2'
            then'/2' 
         when ctf.coment_tmj_f = '/2' and ctf.sens = 'Double sens' and uci.type_correction='divise par 2 -> null'
            then null
         else ctf.coment_tmj_f end as coment_tmj_f,
    ctf.ann_pc_pl,
    ctf.tmja,
    ctf.pc_pl,
    ctf.veh_km,
    ctf.tmja_final,
    ctf.pl,
    ctf.pl_final,
    ctf.pl_km,
    ctf.id_cpt1,
    ctf.id_cpt2,
    ctf.obs_tmj1,
    ctf.obs_tmj2,
    ctf.tmja_cpt1,
    ctf.tmja_cpt2,
    ctf.codau_cat,
    ctf.milieu,
    ctf.codau,
    ctf.type_vdf,
    ctf.vts_vl_vdf,
    ctf.vts_pl_vdf,
    ctf.vts_gest,
    ctf.id_vts,
    ctf.obs_tmja,
    ctf.obs_pc_pl,
    ctf.obs_supl,
    ctf.id_sect,
    ctf.src_sect,
    ctf.autor_sect,
    ctf.obs_vts,
    ctf.vts_osm,
    ctf.vts_modif,
    ctf.vts_vl_f,
    ctf.vts_pl_f,
    ctf.vts_type_vl,
    ctf.vts_type_pl,
    ctf.src_vma,
    ctf.vma_vl,
    ctf.vma_pl,
    ctf.vma_type,
    ctf.codau_cont,
    ctf.id_codau_cont,
    ctf.tmja_cont,
    ctf.pc_pl_cont,
    ctf."source",
    ctf.target,
    ctf.cnt_src,
    ctf.cnt_tgt,
    ctf.imp_sup,
    ctf.imp_sup_src,
    ctf.imp_sup_tgt,
    ctf.recup,
    ctf.id_cnt2,
    ctf.id_struct_rout,
    ctf.id_sect_hom,
    ctf.attr_modif,
    ctf.id_bdc,
    ctf.geom,
    ctf.ang_orient_src_vert1,
    ctf.ang_orient_tgt_vert1,
    ctf.list_id_inter,
    ctf.nb_nod_non_topo,
    ctf.id_struct
from {{ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept)}} ctf
  join {{ref('sed17a_dept' ~ dept ~ '_upd_cmt_tmj_f_sens') }} uci using(id_comptag)
union
select 
    ctf.id_comptag,
    ctf.id_ign,
    ctf.id_simpli,
    ctf.id,
    ctf.nature,
    ctf.nom_coll_g,
    ctf.nom_coll_d,
    ctf.numero,
    ctf.importance,
    ctf.cl_admin,
    ctf.gestion,
    ctf.fictif,
    ctf.largeur,
    ctf.nb_voies,
    ctf.sens,
    ctf.etat,
    ctf.inseecom_g,
    ctf.inseecom_d,
    ctf.id_voie_g,
    ctf.id_voie_d,
    ctf.urbain,
    ctf.vit_moy_vl,
    ctf.restr_p,
    ctf.dept,
    ctf.dept_2024,
    ctf.dept_2023,
    ctf.long_km,
    ctf.src_cpt,
    ctf.coment_cpt,
    ctf.ann_pt,
    ctf.src_cpteur,
    ctf.coment_tmj,
    ctf.coment_tmj_f,
    ctf.ann_pc_pl,
    ctf.tmja,
    ctf.pc_pl,
    ctf.veh_km,
    ctf.tmja_final,
    ctf.pl,
    ctf.pl_final,
    ctf.pl_km,
    ctf.id_cpt1,
    ctf.id_cpt2,
    ctf.obs_tmj1,
    ctf.obs_tmj2,
    ctf.tmja_cpt1,
    ctf.tmja_cpt2,
    ctf.codau_cat,
    ctf.milieu,
    ctf.codau,
    ctf.type_vdf,
    ctf.vts_vl_vdf,
    ctf.vts_pl_vdf,
    ctf.vts_gest,
    ctf.id_vts,
    ctf.obs_tmja,
    ctf.obs_pc_pl,
    ctf.obs_supl,
    ctf.id_sect,
    ctf.src_sect,
    ctf.autor_sect,
    ctf.obs_vts,
    ctf.vts_osm,
    ctf.vts_modif,
    ctf.vts_vl_f,
    ctf.vts_pl_f,
    ctf.vts_type_vl,
    ctf.vts_type_pl,
    ctf.src_vma,
    ctf.vma_vl,
    ctf.vma_pl,
    ctf.vma_type,
    ctf.codau_cont,
    ctf.id_codau_cont,
    ctf.tmja_cont,
    ctf.pc_pl_cont,
    ctf."source",
    ctf.target,
    ctf.cnt_src,
    ctf.cnt_tgt,
    ctf.imp_sup,
    ctf.imp_sup_src,
    ctf.imp_sup_tgt,
    ctf.recup,
    ctf.id_cnt2,
    ctf.id_struct_rout,
    ctf.id_sect_hom,
    ctf.attr_modif,
    ctf.id_bdc,
    ctf.geom,
    ctf.ang_orient_src_vert1,
    ctf.ang_orient_tgt_vert1,
    ctf.list_id_inter,
    ctf.nb_nod_non_topo,
    ctf.id_struct
from {{ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept)}} ctf
where not exists (select 1 from {{ref('sed17a_dept' ~ dept ~ '_upd_cmt_tmj_f_sens') }} uci where ctf.id_comptag=uci.id_comptag)
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_17d_vrf_recup_agglo_lin(dept=var('dept')) %}

select split_part(id_comptag,'-',1) as gest, recup, count(*) as cnt 
  from {{ ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept) }}
  where split_part(id_comptag,'-',1) = ANY(ARRAY[{{var('agglo_' ~ dept)}}])
  group by gest,recup

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_17e_vrf_sens_cmt_tmj_f_h_agglo_lin(dept=var('dept')) %}

select s.*
from (
select t1.id_ign,t1.id_comptag,t1.sens,t2.sens_cpt,t1.coment_tmj_f,
case when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f='*2' then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}' and t1.sens='{{var("bdtopo_double_sens_verif")}}' and t1.coment_tmj_f is null then true
when t2.sens_cpt='{{var("cptg_double_sens_verif")}}' and t1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t1.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f,t1.obs_supl
--t1.obs_tmj1,t1.obs_tmj2,
from {{ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept)}} t1
join {{ source('cptg', 'compteur') }} t2 on t1.id_comptag=t2.id_comptag
where 
(coment_tmj_f is null or coment_tmj_f='/2') --on ne verifie pas les ratio specifique /3,/4,/8
--and split_part(t1.id_comptag,'-',1) not in ('Agglo') --on ne verifie pas les agglo
order by t1.id_comptag,t1.id_ign
) s
where s.verif_coment_tmj_f is false

{%- endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_17f_vrf_sens_tronc_proche_cpt_lin(dept=var('dept'), dist_tronc_cpt=50) %}

select s.*
from (
select distinct on (t1.id_comptag) t1.id_comptag,t1.obs_supl,t2.dept,t1.gestionnai,t1.type_poste,t1.sens_cpt,t2.id_ign,t2.sens as sens_ign,
t2.coment_tmj_f,t2.nature,
case when t1.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t2.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t2.coment_tmj_f is null then true
when t1.sens_cpt='{{var("cptg_sens_uniq_verif")}}' and t2.sens='{{var("bdtopo_double_sens_verif")}}' and t2.coment_tmj_f='*2' then true
when t1.sens_cpt='{{var("cptg_double_sens_verif")}}' and t2.sens='{{var("bdtopo_double_sens_verif")}}' and t2.coment_tmj_f is null then true
when t1.sens_cpt='{{var("cptg_double_sens_verif")}}' and t2.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and t2.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f
from {{source('cptg', 'compteur')}} t1
join {{ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept)}} t2
on t1.id_comptag=t2.id_comptag and st_dwithin(t1.geom,t2.geom,{{dist_tronc_cpt}}) --distance large expres comme join par id_comptag aussi
order by t1.id_comptag, st_distance(t1.geom,t2.geom) asc
) s
where s.verif_coment_tmj_f is false

{%- endmacro %}
