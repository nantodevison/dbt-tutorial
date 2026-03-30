{%- macro cte1_mcr_6_maj_auto_pt_non_linear_lin__choix_cpt_tronc(annee=var('annee'), dept=var('dept')) %}

select distinct on (id_comptag) id_comptag,coment_cpt,id,id_ign,id_simpli,numero,nom_coll_g,importance,route,nature,sim,dist,rg
from ({{cte3_mcr_6_maj_auto_pt_non_linear_lin__rang(annee, dept)}}) t1 order by id_comptag,rg

{% endmacro %}