{% macro mcr_verifier_indic_agrege_after_update_lin(list_id_comptag=[], dept=var('dept'))%}

select t2.id_comptag,t2.annee,t3.type_poste,t1.id, t1.id_comptag_uniq, t1.indicateur, t1.valeur, t1.fichier from comptage.indic_agrege t1 
join comptage.comptage t2 on t1.id_comptag_uniq=t2.id
join comptage.compteur t3 on t2.id_comptag=t3.id_comptag
where t2.id_comptag = ANY(ARRAY{{list_id_comptag}}::varchar[])

{% endmacro %}