{{ 
    config(
    schema='verif',
    )
}}

{{ mcr_15c_vrf_cmt_tmj_f_recup() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ mdl15c_lin_chk_cmt_tmj_f_recup_19(dept='19') }}
#}