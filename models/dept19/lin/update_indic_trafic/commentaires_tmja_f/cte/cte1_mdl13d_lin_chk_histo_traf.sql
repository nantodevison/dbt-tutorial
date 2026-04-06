{{config(
    schema='cte',
)}}

{{ cte1_mcr_13d_vrf_histo_traf_lin() }}

{# documentation d'utilisation :
    appel avec spécification de variable : 
        dbt run --vars '{"dept": "19"}'
    Dans sa forme basée sur les
    variables passées manuellement :
    {{ cte_verifier_historique_trafic_lin(dept='19') }}
#}