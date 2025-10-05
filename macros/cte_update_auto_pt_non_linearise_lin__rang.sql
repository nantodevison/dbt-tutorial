{% macro cte_update_auto_pt_non_linearise_lin__rang(annee=var('annee'), dept=var('dept')) %}

select id_comptag,coment_cpt,id,id_ign,id_simpli,numero,nom_coll_g,importance,route,nature,sim,dist,
case when (id_comptag like '%Entree%' or id_comptag like '%Sortie%') and nature='Bretelle'
then dense_rank()over(partition by id_comptag order by dist asc)
when (id_comptag like '%Entree%' or id_comptag like '%Sortie%') and nature <>'Bretelle'
then dense_rank()over(partition by id_comptag order by dist asc)
else dense_rank()over(partition by id_comptag order by coalesce(sim,null,0) desc,dist asc) end as rg
--,imp_sup,imp_sup_src,imp_sup_tgt
from ({{cte_update_auto_pt_non_linearise_lin__project_cpt(annee, dept)}}) t1

{% endmacro %}