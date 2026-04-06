{{ 
    config(
        schema='verif',
    )
}}

{{ mcr_21b_vrf_pc_pl_after_maj_final_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variables : 
    dbt run --select mdl_verif_lin_pc_pl_after_update_final_19 --vars '{"dept": "19"}'

    appel en utilisant des variables déclarées :
    dbt run --select mdl_verif_lin_pc_pl_after_update_final_19(dept='19')
#}