{% macro cte_verif_historique_trafic_lin(annee=var('annee')) -%}

{% set annees_list = range(annee, 1999, -1) | list + [1900] %}
{% set BdxMet_annees_list = range(2020, (annee|int) + 1, 1) %}

SELECT row_number() OVER () AS gid,
    t1.id_comptag,
    t2.gestionnai,
    t2.route,
    t2.type_poste,
    t2.convention,
    t2.sens_cpt,
    {% for ann in annees_list %}
    t1.tmja_{{ ann }},
    t1.pc_pl_{{ ann }},
    t1.src_{{ ann }},
    t1.obs_{{ ann }},
    t1.periode_{{ ann }},
    {% endfor %}
    t2.geom
   FROM ( SELECT s1.id_comptag,
            {% for ann in annees_list %}
            max(s2.valeur::numeric) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS tmja_{{ ann }},
            max(s2.valeur::numeric) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'pc_pl'::text) AS pc_pl_{{ ann }},
            max(s1.src) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS src_{{ ann }},
            max(s1.obs) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS obs_{{ ann }},
            max(s1.periode::text) FILTER (WHERE s1.annee::bpchar = '{{ ann }}'::bpchar AND s2.indicateur::text = 'tmja'::text) AS periode_{{ ann }}{{ "," if not loop.last }}
            {% endfor %}
            FROM {{ source('cptg', 'comptage') }} s1
             JOIN ( SELECT ss1.id_comptag_uniq,
                        CASE
                            WHEN ss2.id_comptag::text ~~ 'BdxMet-%'::text AND (ss2.annee::bpchar = ANY (ARRAY[{% for ann in BdxMet_annees_list %}'{{ ann }}'::bpchar{% if not loop.last %},{% endif %}{% endfor %}])) AND ss1.indicateur::text = 'tmjo'::text THEN 'tmja'::character varying
                            WHEN ss2.id_comptag::text ~~ 'BdxMet-%'::text AND (ss2.annee::bpchar = ANY (ARRAY[{% for ann in BdxMet_annees_list %}'{{ ann }}'::bpchar{% if not loop.last %},{% endif %}{% endfor %}])) AND ss1.indicateur::text = 'pc_pl_o'::text THEN 'pc_pl'::character varying
                            WHEN ss2.id_comptag::text = 'Soyaux-rue_de_l_isle-d_e.-0.2051;45.6479'::text AND ss1.indicateur::text = 'tmjo'::text THEN 'tmja'::character varying
                            ELSE ss1.indicateur
                        END AS indicateur,
                    ss1.valeur
                   FROM {{ source('cptg', 'indic_agrege') }} ss1
                     JOIN  {{ source('cptg', 'comptage') }} ss2 ON ss1.id_comptag_uniq = ss2.id) s2 ON s1.id = s2.id_comptag_uniq
          WHERE (s2.indicateur::text = ANY (ARRAY['tmja'::character varying::text, 'pc_pl'::character varying::text])) AND (s1.annee::bpchar = ANY (ARRAY[{% for ann in annees_list %}'{{ ann }}'::bpchar{% if not loop.last %},{% endif %}{% endfor %}]))
          GROUP BY s1.id_comptag
          ORDER BY s1.id_comptag) t1
     JOIN {{ source('cptg', 'compteur') }} t2 ON t1.id_comptag::text = t2.id_comptag::text
  ORDER BY t1.id_comptag

{%- endmacro %}