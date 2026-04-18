{{ config(
    schema='verif'
    )
}}

{{ mcr_12b_vrf_cpt_mm_sect_homo_lin(dept=var('dept')) }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_12b_vrf_cpt_mm_sect_homo_lin(dept='19') }}

#}