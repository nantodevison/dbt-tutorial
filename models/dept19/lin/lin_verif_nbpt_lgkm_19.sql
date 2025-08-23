{{ config(
    schema='verif',
)}}
{% set annee_str = var('annee') | string %} 
select count(distinct id_comptag) as nb_pt,
       round(sum(long_km)::numeric) as sum_lg_km
from lineaire.traf{{ var('annee') }}_bdt{{ var('dept') }}_ed{{ annee_str[-2:] }}_l
where id_comptag is not null