{{
    config(
        schema='verif'
    )
}}

{{ mcr_17e_vrf_sens_cmt_tmj_f_h_agglo_lin() }}

{#
    documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_17e_vrf_sens_cmt_tmj_f_h_agglo_lin(dept='19') }}
#}
