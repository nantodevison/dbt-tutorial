{{
    config(
        schema='verif',
    )
}}

{{ mcr_statistiques_linearisation(models_src=ref('mdl_lin_update_coment_tmj_f_estim_' ~ var('dept'))) }}

{# documentation d'utilisation :
    ne pas oublier le referencement du modèle source en paramètre, ne pas oublier que la macro a aussi le
    département en paramètre par défaut tel que défini dans dbt_project.yml
#}