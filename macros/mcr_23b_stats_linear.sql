{% macro mcr_23b_stats_linear(models_src, annee=var('annee')) %}

select round(sum(long_km)::numeric,2)  as long_tot,
(select round(sum(long_km)::numeric,2)  from {{models_src}} where coment_cpt='linearisation') as long_lin,
--round(sum(veh_km)::numeric,2)  as veh_km_tot,
--(select round(sum(veh_km)::numeric,2) from {{models_src}} where coment_cpt='linearisation') as veh_km_lin,
(select round(sum(long_km)::numeric,2)  from {{models_src}} where src_cpt='otv' and ann_pt='{{annee}}') as long_lin_pt_ann_n,
(select round(sum(long_km)::numeric,2)  from {{models_src}} where src_cpt='otv' and ann_pt::int<{{annee}}) as long_lin_pt_inf_ann_n,
(select count(distinct id_comptag) from {{models_src}} where src_cpt='otv') as compteur_otv,
(select count(distinct id_comptag) from {{models_src}} where src_cpt='otv' and ann_pt='{{annee}}') as compteur_otv_pt_ann_n,
(select count(distinct id_comptag) from {{models_src}} where src_cpt='otv' and ann_pt::int<{{annee}}) as compteur_otv_pt_inf_ann_n,
(((select sum(long_km) from {{models_src}} where coment_cpt='linearisation')/sum(long_km))*100)::numeric(5,2) as prc_lin_tot,
(((select sum(long_km) from {{models_src}} where coment_cpt='linearisation' and ann_pt='{{annee}}')/sum(long_km))*100)::numeric(5,2) as prc_lin_ann_n,
(((select sum(long_km) from {{models_src}} where coment_cpt='linearisation' and ann_pt='{{annee}}')/
(select sum(long_km) from {{models_src}} where coment_cpt='linearisation'))*100)::numeric(5,2) as lin_ann_n_lin_tot
from {{models_src}}

{% endmacro %}