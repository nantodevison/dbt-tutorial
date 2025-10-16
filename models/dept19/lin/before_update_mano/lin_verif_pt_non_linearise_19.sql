{{ config(
    schema='verif',
)}}

select id_comptag
 from {{ref('lin_verif_pt_emprise_dept_non_linearise_' ~ var('dept'))}}
union
select id_comptag
 from {{ref('lin_verif_pt_attr_dept_non_linearise_' ~ var('dept'))}}