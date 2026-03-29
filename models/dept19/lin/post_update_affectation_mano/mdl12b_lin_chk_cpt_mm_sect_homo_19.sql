{{ config(
    schema='verif'
    )
}}

{{ verifier_cpt_mm_section_homo_lin(dept=var('dept')) }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ verifier_cpt_mm_section_homo_lin(dept='19') }}

#}