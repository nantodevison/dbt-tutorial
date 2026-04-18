{{
    config(
        schema='verif'
    )
}}

{{ mcr_xx_vrf_cmt_tmj_f_val_lin(ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ var('dept'))) }}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
    dbt run --select lin_verif_coment_tmj_val_19 --vars '{"dept": "19"}'

    appel en utilisant des variables déclarées :
    dbt run --select lin_verif_coment_tmj_val_19(dept='19')
#}
