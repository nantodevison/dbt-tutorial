{{
    config(
        schema='cte'
    )
}}

{{ cte1_mcr_15e_vrf_val_aberr_tmja__ann_n_n_1() }}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ cte1_mdl15e_lin_chk_vals_aberr_tmja_19__ann_n_n_1(dept='19') }}
#}