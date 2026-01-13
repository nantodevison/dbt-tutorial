{% macro verifier_periode_lin(dept=var('dept')) %}

select t1.id_comptag,t1.type_poste,t1.periode
from (select * from {{source('cptg', 'vue_compteur_last_annee_know_tmja_pc_pl')}} 
      where id_comptag like '{{dept}}-D%'
      {% for agglo in var('agglo_' ~ dept) %}
        or id_comptag like '{{agglo}}-%'
      {% endfor %}
     ) t1
join (select distinct id_comptag from {{ ref('lin_update_coment_tmj_f_ids_' ~ dept) }} 
      where id_comptag like '{{dept}}-D%'
      {% for agglo in var('agglo_' ~ dept) %}
        or id_comptag like '{{agglo}}-%'
      {% endfor %}
     ) t2
on t1.id_comptag=t2.id_comptag
where t1.type_poste in ('ponctuel', 'tournant' )
and (t1.periode like '%/07/%' or t1.periode like '%/08/%')

{% endmacro %}