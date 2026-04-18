{{ 
    config(
        schema='verif'
    )
}}

{{ mcr_12e_vrf_nb_tronc_linear_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les variables passées manuellement :
    {{ mcr_12e_vrf_nb_tronc_linear_lin(dept='19') }}
#}