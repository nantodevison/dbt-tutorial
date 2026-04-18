{{ config(
    schema='verif',
) }}
 
{{mcr_13d_vrf_suspect_indic_lin()}}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ mcr_13d_vrf_suspect_indic_lin(dept='19') }}
#}