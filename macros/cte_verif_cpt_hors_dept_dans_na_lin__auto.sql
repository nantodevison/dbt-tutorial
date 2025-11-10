{% macro cte_verif_cpt_hors_dept_dans_na_lin__auto(annee=var('annee')) %}

select c.id_comptag, v.tmja, v.annee_tmja, v.pc_pl, 
       case when v.pc_pl is not null then v.pc_pl*v.tmja/100 else null end as pl
 from ({{cte_verif_cpt_hors_dept_dans_na_lin__list_cpt()}}) c 
    join {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} v using (id_comptag)
 where v.annee_tmja = '{{annee}}' 
    
{% endmacro %}