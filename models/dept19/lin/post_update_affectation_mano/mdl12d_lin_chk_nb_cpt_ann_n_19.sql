{{ config(
    schema='verif'
    )
}}

select ({{ verifier_nb_cpt_ann_n_lin(dept=var('dept'), annee=var('annee')) }}) as nb_cpt_tot, 
       ({{ verifier_nb_cpt_ann_n_lin(dept=var('dept'), annee=var('annee'), suspect=true) }}) as nb_cpt_suspect

{# documentation d'utilisation :
    appel avec spécification de variables : 
        dbt run --select mdl12d_lin_chk_nb_cpt_ann_n_19 --vars '{"dept": "19", "annee": "2024"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ verifier_nb_cpt_ann_n_lin(dept='19', annee='2024') }}

#}