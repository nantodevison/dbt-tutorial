{% macro mcr_12a_vrf_ann_pt_2020_lin(dept=var('dept')) %}

select distinct id_comptag 
    from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }}
    where ann_pt='2020' 
    order by id_comptag

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12b_vrf_cpt_mm_sect_homo_lin(dept=var('dept')) %}

SELECT id_ign,id_simpli,id_comptag 
  FROM {{ref('cte1_mdl12b_lin_chk_cpt_mm_sect_homo_' ~ dept ~ '__linear_tot')}} 
WHERE id_simpli IN 
    (SELECT id_simpli FROM {{ref('cte1_mdl12b_lin_chk_cpt_mm_sect_homo_' ~ dept ~ '__linear_tot')}} 
where dept='{{dept}}' and id_cpt_proch is true 
GROUP BY id_simpli HAVING COUNT(*) > 1)  and dept='{{dept}}' and id_cpt_proch is true
order by id_simpli asc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte1_mcr_12b_vrf_cpt_mm_sect_homo_lin__linear_tot(dept=var('dept'), distance=100) %}

SELECT 
    lin.id, 
    lin.id_ign, 
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
    lin.coment_cpt, 
    lin.id_comptag, 
    lin.src_cpt, 
    lin.obs_supl,
    lin.ann_pt, 
    lin.coment_tmj, 
    lin.coment_tmj_f, 
    lin.tmja, 
    lin.tmja_final, 
    lin.veh_km, 
    lin.ann_pc_pl, 
    lin.pc_pl, 
    lin.pl, 
    lin.pl_final, 
    lin.pl_km, 
    lin.obs_tmja, 
    lin.obs_pc_pl, 
    lin.id_cpt1, 
    lin.id_cpt2, 
    lin.obs_tmj1, 
    lin.obs_tmj2, 
    lin.tmja_cpt1, 
    lin.tmja_cpt2, 
    lin.id_sect, 
    lin.src_sect, 
    lin.autor_sect, 
    lin.codau_cat, 
    lin.milieu, 
    lin.codau, 
    lin.type_vdf, 
    lin.vts_vl_vdf, 
    lin.vts_pl_vdf, 
    lin.vts_gest, 
    lin.id_vts, 
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
    lin.target, 
    lin.cnt_src, 
    lin.cnt_tgt, 
    lin.imp_sup, 
    lin.imp_sup_src, 
    lin.imp_sup_tgt, 
    lin.recup, 
    lin.id_cnt2, 
    lin.id_struct_rout, 
    lin.id_sect_hom, 
    lin.id_simpli, 
    lin.attr_modif, 
    lin.id_bdc, 
    lin.geom, 
    lin.ang_orient_src_vert1, 
    lin.ang_orient_tgt_vert1, 
    lin.list_id_inter, 
    lin.nb_nod_non_topo, 
    lin.id_struct,
    -- Colonne id_cpt_proche
    CASE WHEN cpt_proche.id_comptag IS NOT NULL THEN TRUE ELSE FALSE END AS id_cpt_proch
FROM {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }} lin
LEFT JOIN ({{ cte1_mcr_13a_vrf_cpt_mm_sect_homo_lin__cpt_proche(dept=dept, distance=distance) }}) as cpt_proche 
    ON lin.id_ign = cpt_proche.id_ign 
    AND lin.id_comptag = cpt_proche.id_comptag

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro cte1_mcr_13a_vrf_cpt_mm_sect_homo_lin__cpt_proche(dept=var('dept'), distance=100) %}

select distinct on (s1.id_comptag) s1.id_comptag,s2.id_ign
    from {{source('cptg', 'compteur')}} s1 
      join {{ref('mdl11_lin_upd_vers_estim_' ~ dept)}} s2
on s1.id_comptag=s2.id_comptag and st_dwithin(s1.geom,s2.geom,{{distance}})
where s2.src_cpt='otv'
order by s1.id_comptag,st_distance(s1.geom,s2.geom) asc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12c_vrf_cptg_not_lin_why_geom_dept_lin(annee=var('annee'), dept=var('dept')) %}

select t1.id_comptag, t1.type_poste,t2.annee, t2.not_lin_why, t3.definition
from (select cpt.id_comptag, cpt.type_poste from {{ source('cptg', 'compteur') }} cpt
      join {{ source('admi', 'dpt_bdt_na_ed' ~ (annee|string)[-2:] ~ '_s') }} aire
        on st_within(cpt.geom, aire.geom) where aire.dept = '{{ dept }}' ) t1
join (select id_comptag, annee, not_lin_why from {{ source('cptg', 'comptage') }} where not_lin_why is not null) t2
    on t1.id_comptag = t2.id_comptag
join {{ source('cptg', 'enum_not_lin_why') }} t3
on t2.not_lin_why = t3.code

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12d_vrf_nb_cpt_ann_n_lin(dept=var('dept'), annee=var('annee'), suspect=false) %}

select count(*) nb_cpt
from (
    select distinct id_comptag 
    from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }} 
    where id_comptag is not null
) t1
join (
    select id_comptag 
    from {{ source('cptg', 'comptage') }} 
    where annee = '{{ annee }}' {% if suspect %} and suspect = true {% endif %}
) t2 
on t1.id_comptag = t2.id_comptag

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12e_vrf_nb_tronc_linear_lin(dept=var('dept')) %}

select count(*) filter(where id_comptag is not null) as nb_cpt_lin_id_cptg,
       count(*) filter(where src_cpt='otv')   as nb_cpt_lin_otv
 from {{ ref('mdl11_lin_upd_vers_estim_'~dept) }}
 
{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12f_vrf_not_lin_why_lin(annee=var('annee'), dept=var('dept')) %}

select * 
from {{ source('cptg', 'comptage') }} cpt
where not_lin_why is not null 
and exists (
    select 1 
    from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }} lin
    where lin.id_comptag = cpt.id_comptag 
    and lin.src_cpt = 'otv'
)

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12g_vrf_stats_linear_pt_cptg_lin(annee=var('annee'), dept=var('dept')) %}

select count(distinct id_comptag) filter (where obs_supl like 'nouveau point traf{{ annee }}%') as nb_id_comptag,
       round(sum(long_km) filter (where obs_supl like 'nouveau point traf{{ annee }}%')::numeric,3) as sum_lg_km,
       count(distinct id_comptag) filter (where obs_supl like '%ex%traf{{ annee|int - 1 }}%') as nb_modif_lin,
       count(distinct id_comptag) filter (where obs_supl = 'linearisation etiree traf{{ annee }}') as nb_etire_lin
from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }}

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12h_vrf_tmjo_lin(dept=var('dept')) %}

select distinct on (t2.id_comptag) t2.id_comptag,
       t2.annee,
       t3.gestionnai
from {{ source('cptg', 'indic_agrege') }} t1 
join {{ source('cptg', 'comptage') }} t2 
    on t1.id_comptag_uniq = t2.id
join {{ source('cptg', 'compteur') }} t3 
    on t2.id_comptag = t3.id_comptag
join (
    select distinct id_comptag 
    from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }} 
    where src_cpt = 'otv'
) t4 on t3.id_comptag = t4.id_comptag
where t1.indicateur = 'tmjo'
order by t2.id_comptag, t2.annee

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_12i_maj_indic_traf_lin(dept=var('dept')) %}

-- Remise à null des indicateurs
with 
reset_indic as (
select 
id_comptag,
id_ign,
id_simpli,
id,
nature,
nom_coll_g,
nom_coll_d,
numero,
importance,
cl_admin,
gestion,
fictif,
largeur,
nb_voies,
sens,
etat,
inseecom_g,
inseecom_d,
id_voie_g,
id_voie_d,
urbain,
vit_moy_vl,
restr_p,
dept,
dept_2024,
dept_2023,
long_km,
src_cpt,
coment_cpt,
null as ann_pt,
src_cpteur,
coment_tmj,
coment_tmj_f,
null as ann_pc_pl,
null as tmja,
null as pc_pl,
null as veh_km,
null as tmja_final,
null as pl,
null as pl_final,
null as pl_km,
id_cpt1,
id_cpt2,
obs_tmj1,
obs_tmj2,
tmja_cpt1,
tmja_cpt2,
codau_cat,
milieu,
codau,
type_vdf,
vts_vl_vdf,
vts_pl_vdf,
vts_gest,
id_vts,
obs_tmja,
obs_pc_pl,
obs_supl,
id_sect,
src_sect,
autor_sect,
obs_vts,
vts_osm,
vts_modif,
vts_vl_f,
vts_pl_f,
vts_type_vl,
vts_type_pl,
src_vma,
vma_vl,
vma_pl,
vma_type,
codau_cont,
id_codau_cont,
tmja_cont,
pc_pl_cont,
"source",
"target",
cnt_src,
cnt_tgt,
imp_sup,
imp_sup_src,
imp_sup_tgt,
recup,
id_cnt2,
id_struct_rout,
id_sect_hom,
attr_modif,
id_bdc,
geom,
ang_orient_src_vert1,
ang_orient_tgt_vert1,
list_id_inter,
nb_nod_non_topo,
id_struct
from {{ref('mdl11_lin_upd_vers_estim_' ~ dept)}}
where src_cpt='otv'
union
select 
id_comptag,
id_ign,
id_simpli,
id,
nature,
nom_coll_g,
nom_coll_d,
numero,
importance,
cl_admin,
gestion,
fictif,
largeur,
nb_voies,
sens,
etat,
inseecom_g,
inseecom_d,
id_voie_g,
id_voie_d,
urbain,
vit_moy_vl,
restr_p,
dept,
dept_2024,
dept_2023,
long_km,
src_cpt,
coment_cpt,
ann_pt,
src_cpteur,
coment_tmj,
coment_tmj_f,
ann_pc_pl,
tmja,
pc_pl,
veh_km,
tmja_final,
pl,
pl_final,
pl_km,
id_cpt1,
id_cpt2,
obs_tmj1,
obs_tmj2,
tmja_cpt1,
tmja_cpt2,
codau_cat,
milieu,
codau,
type_vdf,
vts_vl_vdf,
vts_pl_vdf,
vts_gest,
id_vts,
obs_tmja,
obs_pc_pl ,
obs_supl,
id_sect,
src_sect,
autor_sect,
obs_vts,
vts_osm,
vts_modif,
vts_vl_f,
vts_pl_f,
vts_type_vl,
vts_type_pl,
src_vma,
vma_vl,
vma_pl,
vma_type,
codau_cont,
id_codau_cont,
tmja_cont,
pc_pl_cont,
"source",
"target",
cnt_src,
cnt_tgt,
imp_sup,
imp_sup_src,
imp_sup_tgt,
recup,
id_cnt2,
id_struct_rout,
id_sect_hom,
attr_modif,
id_bdc,
geom,
ang_orient_src_vert1,
ang_orient_tgt_vert1,
list_id_inter,
nb_nod_non_topo,
id_struct
from {{ref('mdl11_lin_upd_vers_estim_' ~ dept)}}
where src_cpt != 'otv' or src_cpt is null
)
select 
rs.id_comptag,
rs.id_ign,
rs.id_simpli,
rs.id,
rs.nature,
rs.nom_coll_g,
rs.nom_coll_d,
rs.numero,
rs.importance,
rs.cl_admin,
rs.gestion,
rs.fictif,
rs.largeur,
rs.nb_voies,
rs.sens,
rs.etat,
rs.inseecom_g,
rs.inseecom_d,
rs.id_voie_g,
rs.id_voie_d,
rs.urbain,
rs.vit_moy_vl,
rs.restr_p,
rs.dept,
rs.dept_2024,
rs.dept_2023,
rs.long_km,
rs.src_cpt,
'linearisation' as coment_cpt,
cpt.annee_tmja as ann_pt,
rs.src_cpteur,
rs.coment_tmj,
rs.coment_tmj_f,
cpt.annee_pc_pl as ann_pc_pl,
cpt.tmja,
cpt.pc_pl,
rs.veh_km,
rs.tmja_final,
case when cpt.pc_pl=0 then 0::integer when cpt.pc_pl<>0 then round(cpt.tmja::numeric*(cpt.pc_pl/100.0))::integer else null::integer end pl,
rs.pl_final,
rs.pl_km,
rs.id_cpt1,
rs.id_cpt2,
rs.obs_tmj1,
rs.obs_tmj2,
rs.tmja_cpt1,
rs.tmja_cpt2,
rs.codau_cat,
rs.milieu,
rs.codau,
rs.type_vdf,
rs.vts_vl_vdf,
rs.vts_pl_vdf,
rs.vts_gest,
rs.id_vts,
null as obs_tmja,
case when cpt.pc_pl is null then 'auto' else null end as obs_pc_pl ,
rs.obs_supl,
rs.id_sect,
rs.src_sect,
rs.autor_sect,
rs.obs_vts,
rs.vts_osm,
rs.vts_modif,
rs.vts_vl_f,
rs.vts_pl_f,
rs.vts_type_vl,
rs.vts_type_pl,
rs.src_vma,
rs.vma_vl,
rs.vma_pl,
rs.vma_type,
rs.codau_cont,
rs.id_codau_cont,
rs.tmja_cont,
rs.pc_pl_cont,
rs."source",
rs."target",
rs.cnt_src,
rs.cnt_tgt,
rs.imp_sup,
rs.imp_sup_src,
rs.imp_sup_tgt,
rs.recup,
rs.id_cnt2,
rs.id_struct_rout,
rs.id_sect_hom,
rs.attr_modif,
rs.id_bdc,
rs.geom,
rs.ang_orient_src_vert1,
rs.ang_orient_tgt_vert1,
rs.list_id_inter,
rs.nb_nod_non_topo,
rs.id_struct
from reset_indic rs
left join {{ source('cptg','vue_compteur_last_annee_know_tmja_pc_pl')}} cpt
 on rs.id_comptag = cpt.id_comptag
where rs.src_cpt='otv' and cpt.id_comptag is not null
union
select 
rs.id_comptag,
rs.id_ign,
rs.id_simpli,
rs.id,
rs.nature,
rs.nom_coll_g,
rs.nom_coll_d,
rs.numero,
rs.importance,
rs.cl_admin,
rs.gestion,
rs.fictif,
rs.largeur,
rs.nb_voies,
rs.sens,
rs.etat,
rs.inseecom_g,
rs.inseecom_d,
rs.id_voie_g,
rs.id_voie_d,
rs.urbain,
rs.vit_moy_vl,
rs.restr_p,
rs.dept,
rs.dept_2024,
rs.dept_2023,
rs.long_km,
rs.src_cpt,
rs.coment_cpt,
rs.ann_pt,
rs.src_cpteur,
rs.coment_tmj,
rs.coment_tmj_f,
rs.ann_pc_pl,
rs.tmja,
rs.pc_pl,
rs.veh_km,
rs.tmja_final,
rs.pl,
rs.pl_final,
rs.pl_km,
rs.id_cpt1,
rs.id_cpt2,
rs.obs_tmj1,
rs.obs_tmj2,
rs.tmja_cpt1,
rs.tmja_cpt2,
rs.codau_cat,
rs.milieu,
rs.codau,
rs.type_vdf,
rs.vts_vl_vdf,
rs.vts_pl_vdf,
rs.vts_gest,
rs.id_vts,
rs.obs_tmja,
rs.obs_pc_pl ,
rs.obs_supl,
rs.id_sect,
rs.src_sect,
rs.autor_sect,
rs.obs_vts,
rs.vts_osm,
rs.vts_modif,
rs.vts_vl_f,
rs.vts_pl_f,
rs.vts_type_vl,
rs.vts_type_pl,
rs.src_vma,
rs.vma_vl,
rs.vma_pl,
rs.vma_type,
rs.codau_cont,
rs.id_codau_cont,
rs.tmja_cont,
rs.pc_pl_cont,
rs."source",
rs."target",
rs.cnt_src,
rs.cnt_tgt,
rs.imp_sup,
rs.imp_sup_src,
rs.imp_sup_tgt,
rs.recup,
rs.id_cnt2,
rs.id_struct_rout,
rs.id_sect_hom,
rs.attr_modif,
rs.id_bdc,
rs.geom,
rs.ang_orient_src_vert1,
rs.ang_orient_tgt_vert1,
rs.list_id_inter,
rs.nb_nod_non_topo,
rs.id_struct
from reset_indic rs
left join {{ source('cptg','vue_compteur_last_annee_know_tmja_pc_pl')}} cpt
 on rs.id_comptag = cpt.id_comptag
where rs.src_cpt != 'otv' or rs.src_cpt is null or cpt.id_comptag is null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_13b_vrf_tmjo_exists_tmja_lin(dept=var('dept')) %}

select distinct on (t2.id_comptag) t2.id_comptag,
       t2.annee,
       t3.type_poste,
       t1.id as id_indic_agrege,
       t1.id_comptag_uniq,
       t1.indicateur,
       t1.valeur,
       t1.fichier
from {{ source('cptg', 'indic_agrege') }} t1 
join {{ source('cptg', 'comptage') }} t2 
    on t1.id_comptag_uniq = t2.id
join {{ source('cptg', 'compteur') }} t3 
    on t2.id_comptag = t3.id_comptag
where t1.indicateur = 'tmja' 
and exists (
    select 1 
    from {{ ref('mdl12h_lin_chk_tmjo_' ~ dept) }} tmjo
    where tmjo.id_comptag = t2.id_comptag
)
order by t2.id_comptag, t2.annee::int desc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14a_vrf_stats_linear_nbpt_gest(dept=var('dept'), annee=false) %}


select count(*) as  nb_pt,t2.gestionnai{% if annee %},t1.ann_pt{% endif %}
from (select distinct id_comptag,ann_pt 
        from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} 
        where src_cpt='otv') t1
join {{source('cptg','compteur')}} t2 using (id_comptag)
group by t2.gestionnai{% if annee %},t1.ann_pt{% endif %} order by {% if annee %}t2.gestionnai,t1.ann_pt{% else %}nb_pt{% endif %} desc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14b_vrf_stats_linear_gests_annees(dept=var('dept')) %}

select gestionnai,string_agg(ann_pt||':'||nb_pt,';') as ann_nb_pt
from (
{{mcr_14a_vrf_stats_linear_nbpt_gest(dept, true)}})
group by gestionnai

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14c_vrf_stats_linear_nbpt_lgkm_annee(dept=var('dept')) %}

select count(distinct id_comptag) as nb_pt,round(sum(long_km)::numeric,2) as sum_lg_km,ann_pt 
from {{ref('mdl13c_lin_upd_cpt_hors_dept_dans_na_' ~ dept)}} where src_cpt='otv'
group by ann_pt
order by ann_pt::int desc

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_14d_vrf_indic_agrege_after_maj_lin(list_id_comptag=[], dept=var('dept'))%}

select t2.id_comptag,t2.annee,t3.type_poste,t1.id, t1.id_comptag_uniq, t1.indicateur, t1.valeur, t1.fichier 
from {{source('cptg', 'indic_agrege')}} t1 
join {{source('cptg', 'comptage')}} t2 on t1.id_comptag_uniq=t2.id
join {{source('cptg', 'compteur')}} t3 on t2.id_comptag=t3.id_comptag
where t2.id_comptag = ANY(ARRAY{{list_id_comptag}}::varchar[])

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_18b_vrf_id_cptg_mill_en_cours_lin(dept=var('dept'), annee=var('annee')) %}

select distinct id_comptag 
  from {{ref('mdl17a_lin_upd_cmt_tmj_f_sens_dbl_spl_' ~ dept)}}
  where coment_cpt='linearisation' and ann_pt='{{ annee }}' 
  order by id_comptag

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_18c_vrf_recup_linear_lin(dept=var('dept')) %}

select count(*) as cnt,recup 
 from {{ref('mdl17a_lin_upd_cmt_tmj_f_sens_dbl_spl_' ~ dept)}}
 where coment_cpt='linearisation' 
 group by recup

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_21b_vrf_pc_pl_after_maj_final_lin(dept=var('dept')) %}

select count(*) as count, 
       count(distinct id_comptag) as count_distinct_id_comptag, 
       array_agg(distinct id_comptag) as list_id_comptag,
       array_agg(distinct split_part(id_comptag,'-',1)) as list_split1_id_comptag
    from {{ref('mdl20_lin_upd_pl_final_pl_km_' ~ dept)}}
    where coment_cpt='linearisation' and pc_pl is null

{% endmacro %}

{# ─────────────────────────────────────────────────────────── #}

{% macro mcr_21c_vrf_pc_pl_after_maj_group_gest_lin(dept=var('dept')) %}

select count(distinct id_comptag) as cnt_cpt,split_part(id_comptag,'-',1) as gest 
 from {{ref('mdl20_lin_upd_pl_final_pl_km_' ~ dept)}} 
 where coment_cpt='linearisation' and pc_pl is null 
 group by gest

{% endmacro %}
