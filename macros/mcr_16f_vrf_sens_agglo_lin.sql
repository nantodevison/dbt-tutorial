{% macro mcr_16f_vrf_sens_agglo_lin(dept=var('dept'), annee=var('annee')) %}
{% set ann_n_1 = (annee | int - 1) | string %}

select s.id_ign,s.dept,s.src_cpt,s.id_comptag,s.sens_ed_n,s.sens_ed_n_1,s.recup,
s.coment_tmj_f_ed_n,s.coment_tmj_f_ed_n_1,
s.nature_n,s.nature_n_1
from (
select s1.dept,s1.src_cpt,s1.id,s1.id_ign,s1.id_comptag,s1.recup,
case when s1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then 'Sens unique' else s1.sens end as sens_ed_n,
case when s3.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then 'Sens unique' else s3.sens end as sens_ed_n_1,
case when s1.sens='{{var("bdtopo_double_sens_verif")}}' and s3.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) then true
when s1.sens = ANY(ARRAY{{var('bdtopo_sens_uniq_verif')}}) and s3.sens='{{var("bdtopo_double_sens_verif")}}' then true
else null end as modif_sens,
s1.coment_tmj_f as coment_tmj_f_ed_n,s3.coment_tmj_f as coment_tmj_f_ed_n_1,
s1.nature as nature_n,s3.nature as nature_n_1
from {{ref('mdl15a_lin_upd_cmt_tmj_f_ids_' ~ dept)}} s1 join 
(select ss.id ,ss.id_ign,ss.id_propa,null as pk_ign,ss.ad,ss.imp,ss.topo_n,ss.recurs
from (select distinct on (id_ign) id,id_ign,id_propa,ad,imp,topo_n,recurs from ref.bdt_na_{{ann_n_1}}_{{annee}}_l
where sup is null and id_propa is not null and pk_ign is null order by id_ign, topo_n asc,imp asc,recurs asc) ss) s2
on s1.id_ign=s2.id_ign
join {{source('traf', 'traf' ~ ann_n_1 ~ '_bdt_na_ed' ~ ann_n_1[-2:] ~ '_l')}} s3 on s2.id_propa=s3.id_ign
)s
where s.modif_sens is true and s.recup not in ('ad','pk_ign') and s.src_cpt in ('otv')
and (
  {%- for agglo in var('agglo_19') %}
  s.id_comptag like '{{ agglo }}-%'
  {%- if not loop.last %} or {% endif %}
  {%- endfor %}
)

{% endmacro %}