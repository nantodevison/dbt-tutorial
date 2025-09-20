{{
  config(
    schema = 'affectation_pt_mano',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_affectation_pt_mano_l'
    )
}}

{{ update_nouveau_point_lin() }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{affecter_point_lin(dept='19')}}   
#}
