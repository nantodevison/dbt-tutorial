{{
  config(
    schema = 'affectation_pt_mano',
    )
}}

{{
  config(
    schema = 'affectation_pt_mano',
    )
}}

{{ affecter_point_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{affecter_point_lin(dept='19')}}   
#}
