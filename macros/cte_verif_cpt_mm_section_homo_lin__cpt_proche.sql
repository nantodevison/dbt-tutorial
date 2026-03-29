{% macro cte_verif_cpt_mm_section_homo_lin__cpt_proche(dept=var('dept'), distance=100) %}

select distinct on (s1.id_comptag) s1.id_comptag,s2.id_ign
    from {{source('cptg', 'compteur')}} s1 
      join {{ref('mdl11_lin_upd_vers_estim_' ~ dept)}} s2
on s1.id_comptag=s2.id_comptag and st_dwithin(s1.geom,s2.geom,{{distance}})
where s2.src_cpt='otv'
order by s1.id_comptag,st_distance(s1.geom,s2.geom) asc

{% endmacro %}