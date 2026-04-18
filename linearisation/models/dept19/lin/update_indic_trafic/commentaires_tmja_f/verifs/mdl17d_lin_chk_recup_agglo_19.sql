{{
    config(
        schema='verif'
    )
}}

{{ mcr_17d_vrf_recup_agglo_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl17d_lin_chk_recup_agglo_19(dept='19') }}
#}