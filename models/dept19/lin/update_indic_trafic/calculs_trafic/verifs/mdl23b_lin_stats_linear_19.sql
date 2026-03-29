{{
    config(
        schema='verif',
    )
}}

{{ mcr_statistiques_linearisation(models_src=ref('mdl22_lin_upd_cmt_tmj_f_estim_' ~ var('dept'))) }}

{# documentation d'utilisation :
    ne pas oublier le referencement du modèle source en paramètre, ne pas oublier que la macro a aussi le
    département en paramètre par défaut tel que défini dans dbt_project.yml
#}