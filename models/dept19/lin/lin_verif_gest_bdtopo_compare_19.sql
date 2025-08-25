{{ config(
    schema='verif',
)}}

{% set annee2 = var('annee') | int - 1 %}

{{comparer_gestionnaire_bdtopo_lin(annee1=var('annee'), annee2=annee2, dept=var('dept'))}}