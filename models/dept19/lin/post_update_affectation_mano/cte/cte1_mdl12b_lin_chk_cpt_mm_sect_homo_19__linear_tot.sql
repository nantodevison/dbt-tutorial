{{
  config(
    schema = 'cte'
  )
}}

{{ cte1_mcr_12b_vrf_cpt_mm_sect_homo_lin__linear_tot(dept=var('dept'), distance=100) }}

{#  Documentation d'utilisation :
    appel avec spécification de variable: 
        dbt run --vars '{"dept": "19", "distance": "50"}'
    Dans sa forme basée sur les des variables passées manuellement :
        {{update_cpt_mm_section_homo(dept='19', distance=50)}}
#}