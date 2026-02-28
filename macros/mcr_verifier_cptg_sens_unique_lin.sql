{% macro mcr_verifier_cptg_sens_unique_lin(model_src, dept=var('dept')) %}

select t1.id_comptag from 
    (select distinct id_comptag 
        from {{ model_src }} where id_comptag is not null) t1
    join {{source('cptg', 'compteur')}} t2 using(id_comptag)
    where t2.sens_cpt='{{ var("cptg_sens_uniq_verif") }}'

{% endmacro %}

