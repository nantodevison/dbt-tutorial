{{
      config(
        schema = 'verif',
        )
}}

{{ verifier_split_id_comptag_lin('lin_update_cpt_hors_dept_dans_na_19') }}

{# 
documentation d'utilisation :
    appel en utilisant des variables déclarées :
    dbt run --select lin_verif_id_comptag_part1_post_coment_tmj_f_19(model='xxx', separator=';', part=2)
#}