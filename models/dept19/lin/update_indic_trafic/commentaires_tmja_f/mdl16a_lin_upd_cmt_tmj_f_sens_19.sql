{{ 
    config(
        schema='update',
        alias='traf' ~ var('annee') ~ '_bdt' ~ var('dept') ~'_ed' ~ (var('annee')|string)[-2:] ~ '_coment_tmj_f_sens_l'
)}}

{{ update_coment_tmj_f_with_ids(ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ var('dept'))) }}   

{# documentation d'utilisation :
    ne pas oublier le referencement du modèle source en paramètre, ne pas oublier que la macro a aussi le
    département en paramètre par défaut tel que défini dans dbt_project.yml
#}