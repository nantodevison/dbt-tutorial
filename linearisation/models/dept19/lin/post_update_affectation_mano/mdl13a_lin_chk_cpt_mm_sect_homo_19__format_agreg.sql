{{ config(
    schema='verif'
    )
}}

select id_simpli,array_agg(distinct id_comptag) as list_id_cpt
 FROM {{ref('mdl12b_lin_chk_cpt_mm_sect_homo_19')}}
 group by id_simpli

{# variation du modele mdl12b_lin_chk_cpt_mm_sect_homo_19 
    avec agregation des id_comptag sous forme d'array, selon
    l'attribut id_simpli
#}