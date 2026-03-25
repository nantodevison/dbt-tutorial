{{ config(
    schema='cte',
) }}

{{cte_verif_cpt_hors_dept_dans_na_lin__auto()}}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ cte_verif_cpt_hors_dept_dans_na_lin__auto(dept='19') }}
#}