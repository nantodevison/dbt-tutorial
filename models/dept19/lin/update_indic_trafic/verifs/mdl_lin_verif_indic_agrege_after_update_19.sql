{{ 
    config(
        schema='verif',
    )
}}

{{ mcr_verifier_indic_agrege_after_update_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variables : 
    dbt run --select mdl_lin_verif_indic_agrege_after_update_19 --vars '{"dept": "19"}'

    appel en utilisant des variables déclarées :
    dbt run --select mdl_lin_verif_indic_agrege_after_update_19(dept='19')
#}
