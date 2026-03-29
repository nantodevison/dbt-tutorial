{{
    config(
        schema="verif"
    )
}}

{{ mcr_verifier_sens_bretelles_rrn_lin() }}

{#
documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl16g_lin_chk_sens_bret_rrn_19(dept='19') }}
#}