{% macro mcr_12g_vrf_stats_linear_pt_cptg_lin(annee=var('annee'), dept=var('dept')) %}

select count(distinct id_comptag) filter (where obs_supl like 'nouveau point traf{{ annee }}%') as nb_id_comptag,
       round(sum(long_km) filter (where obs_supl like 'nouveau point traf{{ annee }}%')::numeric,3) as sum_lg_km,
       count(distinct id_comptag) filter (where obs_supl like '%ex%traf{{ annee|int - 1 }}%') as nb_modif_lin,
       count(distinct id_comptag) filter (where obs_supl = 'linearisation etiree traf{{ annee }}') as nb_etire_lin
from {{ ref('mdl11_lin_upd_vers_estim_' ~ dept) }}

{% endmacro %}