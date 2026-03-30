{% macro mcr_12e_vrf_nb_tronc_linear_lin(dept=var('dept')) %}

select count(*) filter(where id_comptag is not null) as nb_cpt_lin_id_cptg,
       count(*) filter(where src_cpt='otv')   as nb_cpt_lin_otv
 from {{ ref('mdl11_lin_upd_vers_estim_'~dept) }}
 
{% endmacro %}