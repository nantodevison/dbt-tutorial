{{ 
    config(
        schema='update',
        alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_coment_tmj_f_sens_dbl_spl_l')
}}   

{{ mcr_update_coment_tmj_f_sens_lin() }}   

{#
    documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl17a_lin_upd_cmt_tmj_f_sens_dbl_spl_19(dept='19') }}
#}