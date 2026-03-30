{% macro cte2_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__list_cpt(dept=var('dept')) %}

select distinct l.id_comptag, c.type_poste
 from {{ref('mdl12i_lin_upd_indic_traf_' ~ dept)}} l
      join {{source('cptg', 'compteur')}} c using (id_comptag),
      lateral (select split_part(l.id_comptag,'-',1) as depart) d
 where l.id_comptag is not null and d.depart = any(array{{var('dept_na')}}) and d.depart != '{{dept}}'
    
{% endmacro %}