{% macro verifier_pt_sans_geom_lin(dept=var('dept')) %}

select distinct on (t2.id_comptag) t2.id_comptag,
t3.gestionnai,t3.type_poste,t2.annee,t2.periode,t1.id, t1.id_comptag_uniq, t1.indicateur, t1.valeur, t1.fichier
from {{source('cptg', 'indic_agrege')}} t1 
join {{source('cptg', 'comptage')}} t2 on t1.id_comptag_uniq=t2.id
join {{source('cptg', 'compteur')}} t3 on t2.id_comptag=t3.id_comptag
where t3.dep='{{ dept }}' and t1.indicateur='tmja' and t3.geom is null
order by t2.id_comptag,t2.annee desc

{% endmacro %}