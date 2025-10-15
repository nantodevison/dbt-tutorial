{{ config(
    schema='cte'
) }}

{{cte_update_auto_pt_non_linearise_lin__choix_cpt_tronc(annee=var('annee'), dept=var('dept'))}}
{# 
  Documentation d'utilisation :
    j'aurais aimé faire appel à des macros, mais j'ai l'erreur de dépendance dbt was unable to infer all dependencies for the model "lin_cte_update_auto_pt_non_linearise_19__choix_cpt_tronc"
    je reste donc sur du code direct dans le modele
#}