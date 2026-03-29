{% macro cte_verif_evol_cpt_dev_assoc__pt_ann_n_asso(dept=var('dept'), annee=var('annee')) %}

select * 
  from (select id_comptag, ann_pt, tmja from {{ref('cte4_mdl16e_lin_chk_evo_cpt_dev_assoc_19__pt_ann_n')}}) t3
    join (select id_cpteur_asso, type_poste, id_cpteur_ref
          from {{source('cptg_assoc', 'compteur')}}) t4 on t3.id_comptag = t4.id_cpteur_asso

{% endmacro %}