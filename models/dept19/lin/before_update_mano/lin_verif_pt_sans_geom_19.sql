{{ config(
    schema='verif',
)}}

{{ verifier_pt_sans_geom_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"annee": 2024, "dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
    {{ verifier_pt_sans_geom_lin(annee=2024, dept='19') }}
#}
