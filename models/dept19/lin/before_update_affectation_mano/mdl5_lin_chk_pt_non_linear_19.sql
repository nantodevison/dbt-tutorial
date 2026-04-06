{{ config(
    schema='verif',
)}}

select id_comptag
 from {{ref('mdl4b_lin_chk_pt_emprise_dept_non_linear_' ~ var('dept'))}}
union
select id_comptag
 from {{ref('mdl4a_lin_chk_pt_attr_dept_non_linear_' ~ var('dept'))}}