{{ 
    config(
        schema="verif"
    )
}}

{{ mcr_xx_vrf_cptg_sens_unique_lin(ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ var('dept'))) }}

{#  
documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{model_src: "ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept)", "dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_verif_cptg_sens_unique_19(model_src=ref('mdl15a_lin_upd_cmt_tmj_f_ids_19'), dept='19') }}
#}