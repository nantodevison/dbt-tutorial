{{
    config(
        schema='verif'
    )
}}

{{ mcr_verifer_id_comptag_mill_en_cours_lin() }}

{#
    documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mdl_lin_verif_id_comptag_millessime_en_cours(dept='19', annee='2024') }}
#}