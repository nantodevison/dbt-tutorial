{% macro mcr_verifier_evo_cptg_devient_asso_lin(dept=var('dept'), annee=var('annee')) %}

select t1.id_cpteur_asso,t1.ann_pt as ann_lin_n_1,t1.tmja as tmja_lin_n_1,t1.type_poste as typ_post_lin_n_1,
t1.id_cpteur_ref,t2.ann_pt as ann_lin_n,t2.tmja as tmja_lin_n,t3.type_poste as typ_post_lin_n,
round(t2.tmja-t1.tmja) as diff_n_n_1,
round(((t2.tmja-t1.tmja)::numeric/t1.tmja::numeric)*100.0,2)as evol_n_n_1
from ({{cte_verif_evol_cpt_dev_assoc__pt_ann_n_asso(dept, annee)}}) t1
join (select distinct id_comptag,ann_pt,tmja from {{ ref('lin_update_coment_tmj_f_ids_' ~ dept) }} where id_comptag is not null) t2
on t1.id_cpteur_ref=t2.id_comptag
join {{source('cptg', 'compteur')}} t3 on t1.id_cpteur_ref=t3.id_comptag

{% endmacro %}