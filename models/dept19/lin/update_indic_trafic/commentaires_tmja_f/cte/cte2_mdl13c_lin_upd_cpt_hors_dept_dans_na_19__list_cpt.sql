{{ config(
    schema='cte',
) }}


{{cte2_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__list_cpt()}}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ cte_verif_cpt_hors_dept_dans_na_lin(dept='19') }}
#}