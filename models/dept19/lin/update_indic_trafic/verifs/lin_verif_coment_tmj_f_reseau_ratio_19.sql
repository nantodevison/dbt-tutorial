{{
    config(
        schema='verif'
    )
}}

{{ verifier_coment_tmj_f_reseau_ratio_lin() }}

{#  documentation d'utilisation :
    appel avec spécification de variables : 
    dbt run --select lin_verif_coment_tmj_reseau_ratio_19 --vars '{"dept": "19"}'

    appel en utilisant des variables déclarées :
    dbt run --select lin_verif_coment_tmj_reseau_ratio_19(dept='19')    
#}