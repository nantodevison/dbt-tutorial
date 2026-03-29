{{
      config(
        schema = 'verif',
        )
}}

{{ verifier_split_id_comptag_lin('mdl13c_lin_upd_cpt_hors_dept_dans_na_19') }}

{# 
documentation d'utilisation :
    appel en utilisant des variables déclarées :
    dbt run --select mdl13e_lin_chk_id_cptg_part1_post_cmt_tmj_f_19(model='xxx', separator=';', part=2)
#}