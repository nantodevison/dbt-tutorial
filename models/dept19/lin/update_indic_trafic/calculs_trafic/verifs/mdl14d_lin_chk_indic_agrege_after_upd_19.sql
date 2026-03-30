{{ 
    config(
        schema='verif',
    )
}}

{{ mcr_14d_vrf_indic_agrege_after_maj_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variables : 
    dbt run --select mdl14d_lin_chk_indic_agrege_after_upd_19 --vars '{"dept": "19"}'

    appel en utilisant des variables déclarées :
    dbt run --select mdl14d_lin_chk_indic_agrege_after_upd_19(dept='19')
#}
