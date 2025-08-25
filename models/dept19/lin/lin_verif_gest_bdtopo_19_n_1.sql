{% set annee = var('annee') | int - 1 %}
{{config(schema='verif') }}

{{verifier_gestionnaire_bdtopo_lin(annee=annee)}}