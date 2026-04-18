{{ config(
    schema='verif',
)}}

{% set annee2 = var('annee') | int - 1 %}

{{mcr_2e_cmp_gest_bdt_lin(annee1=var('annee'), annee2=annee2, dept=var('dept'))}}