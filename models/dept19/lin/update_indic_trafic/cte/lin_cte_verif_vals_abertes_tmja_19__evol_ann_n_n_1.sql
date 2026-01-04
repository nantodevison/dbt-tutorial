{{
    config(
        schema='cte'
    )
}}

{{ cte_verif_valeurs_aberrantes_tmja__evol_ann_n_n_1() }}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ lin_cte_verif_vals_abertes_tmja_19__evol_ann_n_n_1(dept='19') }}
#}