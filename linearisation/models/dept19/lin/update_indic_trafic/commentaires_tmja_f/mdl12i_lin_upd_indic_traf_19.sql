{{ config(
    schema='update',
    alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_indic_trafic_l'
)}}

{{ mcr_12i_maj_indic_traf_lin() }}



{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ mcr_12i_maj_indic_traf_lin(dept='19') }}
#}