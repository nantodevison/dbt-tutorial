{% set annee = var('annee') | int - 2 %}
{{config(schema='verif') }}

{{mcr_xx_vrf_gest_bdt_lin(annee=annee)}}
