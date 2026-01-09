{{
    config(
        schema='cte',
    )
}}


WITH pt_ann_n as (
select t1.*
from
(select  * from lineaire.traf2023_bdt_na_ed23_l where dept='19' ) t1
left join (select  * from lineaire_update.traf2024_bdt19_ed24_coment_tmj_f_ids_l ) t2
on t1.id_comptag=t2.id_comptag),
asso as (
select t4.id_cpteur_asso,t4.type_poste as typ_post_lin_n_1,
t4.id_cpteur_ref from lineaire_cte.lin_cte_verif_evol_cpt_dev_assoc_19__pt_ann_n t3 join comptage_assoc.compteur t4 on t3.id_comptag=t4.id_cpteur_asso
)
select id_cpteur_asso from asso
{#
documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ lin_cte_verif_evolution_cptg_devenu_assoc_19__pt_ann_n_asso(dept='19', annee='2024') }}
#}