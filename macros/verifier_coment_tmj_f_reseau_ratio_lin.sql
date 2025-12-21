{% macro verifier_coment_tmj_f_reseau_ratio_lin(dept=var('dept')) %}

select distinct left(split_part(id_comptag,'-',2),1) as reseau,
                split_part(coment_tmj_f,'/',2)::int as ratio
from {{ref('lin_update_cpt_hors_dept_dans_na_' ~ dept)}}
where src_cpt='otv' and split_part(id_comptag,'-',1)  ~ '^[0-9]+$' 
      and coment_tmj_f like '/%'
order by reseau,ratio

{% endmacro %}