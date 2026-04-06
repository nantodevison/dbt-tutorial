{{
    config(
        schema='verif'
    )
}}

{{ mcr_14f_vrf_annee_rrn_pas_dispo() }}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_14f_vrf_annee_rrn_pas_dispo(dept='19', annee='2024') }}
#}
