{%macro cte_verif_evol_cpt_dev_assoc__id_cptg_n_1(dept=var('dept'), annee=var('annee')) %}
{% set annee_n_1 = (annee | int - 1) | string %}

select distinct id_comptag, ann_pt, tmja from {{ source('traf', 'traf'~annee_n_1~'_bdt_na_ed'~annee_n_1[-2:]~'_l') }} where dept='{{dept}}' and id_comptag is not null

{% endmacro %}