{{ config(
    schema='update',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_indic_trafic_l'
)}}

{{ update_indic_trafic_lin() }}



{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ update_indic_trafic_lin(dept='19') }}
#}