{{
    config(
        schema='verif'
    )
}}

{{ verifier_coment_tmj_f_values_lin(ref('lin_update_cpt_hors_dept_dans_na_' ~ var('dept'))) }}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
    dbt run --select lin_verif_coment_tmj_val_19 --vars '{"dept": "19"}'

    appel en utilisant des variables déclarées :
    dbt run --select lin_verif_coment_tmj_val_19(dept='19')
#}
