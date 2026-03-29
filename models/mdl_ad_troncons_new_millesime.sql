{{
    config(
        schema='bascule_millesime'
    )
}}

{{mcr_ajouter_troncon_nouveau_millesime()}}

{#  documentation d'utilisation :
        appel : dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ mdl_ad_troncons_new_millesime(annee=2024, dept='19') }}
#}
