{{
    config(
        schema='verif'
    )
}}

{{ mcr_verifier_cptg_sens_unique_lin(ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ var('dept'))) }}

{#
    documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{model_src: "ref('mdl16a_lin_upd_cmt_tmj_f_sens_' ~ dept)", "dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_verif_cptg_sens_unique_19(model_src=ref('mdl16a_lin_upd_cmt_tmj_f_sens_19'), dept='19') }}
#}