-- depends_on: {{ ref('mdl2b_lin_chk_dept_limitr_19') }}
{{ config(
    schema='verif'
) }}
{{ verifier_comptage_limitrophe_lin() }}