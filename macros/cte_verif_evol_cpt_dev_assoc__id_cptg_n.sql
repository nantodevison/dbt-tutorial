{% macro cte_verif_evol_cpt_dev_assoc__id_cptg_n(dept=var('dept')) %}


select distinct id_comptag from {{ ref('lin_update_coment_tmj_f_ids_' ~ dept) }}where id_comptag is not null

{% endmacro %}