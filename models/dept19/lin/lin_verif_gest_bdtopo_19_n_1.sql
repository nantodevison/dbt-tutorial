{% set annee = var('annee') | int - 2 %}
{{config(schema='verif') }}

{{verifier_gestionnaire_bdtopo_lin(annee=annee)}}