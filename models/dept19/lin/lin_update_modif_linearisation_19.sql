{{
  config(
    schema = 'affectation_pt_mano',
    )
}}

{{ update_modif_linearisation_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", annee: "2024"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{update_modif_linearisation_lin(dept='19', annee='2024')}}
#}