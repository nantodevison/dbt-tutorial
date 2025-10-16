-- depends_on: {{ ref('lin_verif_dept_limitrophe_19') }}
{{ config(
    schema='verif'
) }}
{{ verifier_comptage_limitrophe_lin() }}