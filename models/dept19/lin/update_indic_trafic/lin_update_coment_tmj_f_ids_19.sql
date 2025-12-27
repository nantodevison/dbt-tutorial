{{ 
    config(
        schema='update',
        alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_coment_tmj_f_ids_l'
)}}

{{ update_coment_tmj_f_with_ids() }}   

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ lin_update_coment_tmj_f_ids_19(dept='19') }}
#}

