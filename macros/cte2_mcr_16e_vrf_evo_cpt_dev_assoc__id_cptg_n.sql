{% macro cte2_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n(dept=var('dept')) %}


select distinct id_comptag from {{ ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept) }} where id_comptag is not null

{% endmacro %}