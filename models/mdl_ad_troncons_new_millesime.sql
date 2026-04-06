{{
    config(
        schema='bascule_millesime'
    )
}}

{{mcr_xx_aj_tronc_nouv_mill()}}

{#  documentation d'utilisation :
        appel : dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ mdl_ad_troncons_new_millesime(annee=2024, dept='19') }}
#}
