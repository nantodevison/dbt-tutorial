{% macro comparer_gestionnaire_bdtopo_lin(annee1, annee2, dept) %}
with
annee_n as ({{verifier_gestionnaire_bdtopo_lin(annee=annee1, dept=dept)}}),
annee_n_1 as ({{verifier_gestionnaire_bdtopo_lin(annee=annee2, dept=dept)}}),
row_union as (
        select
            *
        from
            annee_n
        union all
        select
            *
        from
            annee_n_1
    )
SELECT
    MAX(
        CASE
            WHEN annee = '_{{annee1}}' THEN gestionaire
            ELSE NULL
        END
    ) AS gestionnaire_annee_n,
    MAX(
        CASE
            WHEN annee = '_{{annee2}}' THEN gestionaire
            ELSE NULL
        END
    ) AS gestionnaire_annee_2
FROM
    (
        select
            annee,
            gestionaire,
            ROW_NUMBER() OVER (
                PARTITION BY
                    annee
                ORDER BY
                    id
            ) as row_id
        from
            row_union
    ) DS
GROUP BY
    row_id
ORDER BY
    row_id
{% endmacro %}