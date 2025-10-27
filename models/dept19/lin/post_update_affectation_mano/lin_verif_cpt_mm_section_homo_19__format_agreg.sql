{{ config(
    schema='verif'
    )
}}

select id_simpli,array_agg(distinct id_comptag) as list_id_cpt
 FROM {{ref('lin_verif_cpt_mm_section_homo_19')}}
 group by id_simpli

{# variation du modele lin_verif_cpt_mm_section_homo_19 
    avec agregation des id_comptag sous forme d'array, selon
    l'attribut id_simpli
#}