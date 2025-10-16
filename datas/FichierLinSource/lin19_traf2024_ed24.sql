/*=====================
RECHERCHER/REMPLACER
===================*/
lineaire.traf2023_bdt19_ed23_l => lineaire.traf2024_bdt19_ed24_l
lineaire.traf2024_bdt_na_ed24_l => lineaire.traf2024_bdt_na_ed24_l
lineaire.traf2022_bdt19_ed22_l => lineaire.traf2023_bdt19_ed23_l
lineaire.traf2022_bdt_na_ed22_l => lineaire.traf2023_bdt_na_ed23_l
ref.bdt_na_2022_2023_l => ref.bdt_na_2023_2024_l
aire.dpt_bdt_na_ed23_s => aire.dpt_bdt_na_ed24_s

/*===================================================
Creation de la vue lineaire.traf2024_bdt19_ed24_l 
=====================================================*/
DROP VIEW IF EXISTS lineaire.traf2024_bdt19_ed24_l;
CREATE or REPLACE VIEW lineaire.traf2024_bdt19_ed24_l as 
select * from lineaire.traf2024_bdt_na_ed24_l where dept='19';

/*=============
INFOS DONNEES
============*/
--Dossier des données sources
C:\Users\vincent.vaillant\Box\OTV\donnees_gestionnaires\CD19\en_cours
--Carte des trafics 2017 du CD19
https://www.correze.gouv.fr/Publications/Cartes-et-donnees/Des-cartes-thematiques/Transports-deplacements/ROUTE-Carte-des-trafics-routiers-de-la-Correze-en-2017

/*===========
RECHERCHE WEB
=============*/
--nouvelle déviation CD19
--déviation CD19, 19
--classement sonore Tulle
--classement sonore Brive
--classement sonore Ussac
--PPBE Tulle
--PPBE Brive
--PPBE Malemort : https://www.communedemalemort.fr/fr/actualites/plan-de-pr%C3%A9vention-du-bruit-dans-lenvironnement-ppbe
--3.3 km sur Malemort avec >=8200 veh/Jr
https://communedemalemort.fr/wp-content/uploads/2025/06/20240404-31-Annexe-approbation-PPBE.pdf#page=33

--deviation de malemort : mise en service le 17 mars 2022
https://www.correze.fr/sites/default/files/correzemag154.pdf
p17

/*===============================================================================================================
Troncon dont nature not in ('Quasi-autoroute','Autoroute','Bretelle','Route à 1 chaussée','Route à 2 chaussées')
=================================================================================================================*/
--Quelques tronçons restants peuvent avoir une nature de type de 'Route empierrée','Escalier'
--Verifier si possibilité de les supprimer ou de les laisser (coquille IGN ou continuité de réseau)

select --ign
coment_cpt,nature,round((sum(long_km))::numeric,2) as sum_lg_km,count(*) cnt 
from lineaire.traf2024_bdt19_ed24_l where
nature not in ('Bretelle','Rond-point','Route à 1 chaussée','Route à 2 chaussées','Type autoroutier')
group by coment_cpt,nature;
coment_cpt,nature,sum_lg_km,cnt
--ed24
"estimation"	"Chemin"		0.14	2
"estimation"	"Route empierrée"	0.85	5
--ed23
"estimation"	"Chemin"		0.14	2
"estimation"	"Route empierrée"	0.85	5
--ed22
"estimation"	"Chemin"		0.14	2
"estimation"	"Route empierrée"	0.85	5
--ed21
"estimation"	"Chemin"		0.14	2
"estimation"	"Route empierrée"	0.85	5

/*================================================================
Comparaison nb de pts et lg_km linéarisés en annee_n et annee_n_1
==================================================================*/
--ed24
select count(distinct id_comptag) as nb_pt,round(sum(long_km)::numeric) as sum_lg_km from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null;

nb_pt,sum_lg_km
168	1459

--ed23
--au 202409 (avec juste import schema comptage )
nb_pt,sum_lg_km

--au 202409 (apres maj des indic de trafic)
nb_pt,sum_lg_km


--au 202409 (apres verif sectionnement complet)


--ed22
nb_pt,sum_lg_km
160	1437


/*===================================
Gestionnaire de voire dans le 19
=====================================*/
select distinct gestion from lineaire.traf2024_bdt19_ed24_l;
select '('''||  array_to_string(array(select distinct gestion from lineaire.traf2024_bdt19_ed24_l order by gestion),''',''') ||''')';
--ed24
('ASF','Cantal','Corrèze','Corrèze/Puy-de-Dôme','Creuse','DIR Centre Ouest','Dordogne','Haute-Vienne','Lot')

--ed23
('ASF','Cantal','Corrèze','Corrèze/Puy-de-Dôme','Creuse','DIR Centre Ouest','Dordogne','Haute-Vienne','Lot')

--ed22
--('ASF','Cantal','Corrèze','Creuse','DIR Centre Ouest','Dordogne','Haute-Vienne','Lot')

--Table OTV de réference pour traf2023 comptage.compteur
select array_to_string(array(select distinct gestionnai from comptage.compteur where id_comptag like '19-%' order by gestionnai),''',''') ;
--ASF','CD19','DIRCO


/*==============================
Départements limitrophes hors NA
==============================*/
select '('''||  array_to_string(array(
select distinct t1.insee_dep from
(select insee_dep,geom from aire.com_bdt_na_ed24_s) t1 join
(select gid,dept,geom from aire.dpt_bdt_na_ed24_s where dept='19') t2  
on st_intersects(t1.geom,t2.geom)
where t1.insee_dep<>'19' order by t1.insee_dep
),''',''') ||''')';

--ed24
('15','23','24','46','63','87')
--ed23
('15','23','24','46','63','87')
--ed22
--('15','23','24','46','63','87')
--dept hors NA 
--('15','46','63')

--'46' =>  1 points depuis traf2021 : 46-D120-0+0
--'15' => données dispo sur site du CD15 aucun pts linéarisables dans le 19
C:\Users\vincent.vaillant\Box\OTV\donnees_gestionnaires\limitrophes\CD15\hors_convention\2022
--'63' => pas de données dispos sur site du CD63 (comptage routier cd63)
https://www.puy-de-dome.fr/routes-deplacements.html

--Nb
--si besoin verifier les données sources

select t2.id_comptag,t2.annee,t3.type_poste,t1.*
from comptage.indic_agrege t1 
join comptage.comptage t2 on t1.id_comptag_uniq=t2.id
join comptage.compteur t3 on t2.id_comptag=t3.id_comptag
where t2.id_comptag='' and t2.annee='';


/*================
VERIF attr_modif
================*/
--ed24 : 0 rows
--ed23 : 52 rows
--ed22 : 4 rows
--pour voir id_ign
select 
t1.id_ign,
t1.nature,t1.coment_cpt,t1.id_comptag,t1.numero as num_n,t2.numero as num_n_1,t1.importance as imp_n,t2.importance as imp_n_1, 
t1.obs_supl as obs_n,t2.obs_supl as obs_n_1
--,count(*) as cnt
from lineaire.traf2024_bdt_na_ed24_l t1
left join lineaire.traf2023_bdt_na_ed23_l t2
on t1.id_ign=t2.id_ign
where t1.attr_modif is not null
and t1.dept='19'
order by t1.id_comptag
--group by t1.numero,t2.numero,t1.importance,t2.importance,t1.nature,t1.coment_cpt,t1.id_comptag,t1.obs_supl,t2.obs_supl order by cnt desc,t1.numero;


--regroupement par numero pour faciliter verif
--ed24 : 0 rows
--ed23 : 13 rows
--ed22: 2 rows 
select 
--t1.id_ign,
t1.nature,t1.src_cpt,t1.coment_cpt,t1.id_comptag,coalesce(t1.numero,'NULL') as num_n,coalesce(t2.numero,'NULL') as num_n_1,
t1.importance as imp_n,t2.importance as imp_n_1, 
t1.obs_supl as obs_n,t2.obs_supl as obs_n_1
,count(*) as cnt
from lineaire.traf2024_bdt_na_ed24_l t1
left join lineaire.traf2023_bdt_na_ed23_l t2
on t1.id_ign=t2.id_ign
where t1.attr_modif is not null
and t1.dept='19'
group by t1.numero,t2.numero,t1.importance,t2.importance,t1.nature,t1.coment_cpt,t1.src_cpt,t1.id_comptag,t1.obs_supl,t2.obs_supl
order by t1.id_comptag
--order by cnt desc,t1.numero;

/*VERIF*/
--ed24
--aucune vérif nécessaire

--ed23
id_comptag='19-A89-181+0' and numero='D170E2',bretelles RRN + 2 RP
--UPDATE 26 LE 20240906
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
coment_tmj_f=case when sens in ('Sens direct','Sens inverse') then '/2' when sens='Double sens' then null else null end,
obs_supl='maj a estimation traf2023,ex '||id_comptag||' /12 traf2022'
where id_ign in ('TRONROUT0000000356963785','TRONROUT0000000220022695','TRONROUT0000000356963789','TRONROUT0000000220022925','TRONROUT0000000220023016',
'TRONROUT0000000356963780','TRONROUT0000000220023056','TRONROUT0000000220022694','TRONROUT0000000356963782','TRONROUT0000000356963788',
'TRONROUT0000000356963787','TRONROUT0000000220022725','TRONROUT0000000356963784','TRONROUT0000000357691806','TRONROUT0000000217447144',
'TRONROUT0000000220023006','TRONROUT0000000220022904','TRONROUT0000000220022934','TRONROUT0000000217447146','TRONROUT0000000220022724',
'TRONROUT0000000220022722','TRONROUT0000000220022956','TRONROUT0000000220022968','TRONROUT0000000220022701','TRONROUT0000000356963777',
'TRONROUT0000000220023057');

id_comptag='19-D1089-70+0' and numero='D26',laisser en l'état,continuité importance 2

id_comptag='19-D1089-87+106' and numero='D1089EC1',bretelle,laisser en l'état
id_comptag='19-D1089-87+106' and numero='D1089EC2',bretelle,laisser en l'état
id_comptag='19-D1089E1-118+500' and numero is null,bretelles,laisser en l'état car continuité imprortance 2
id_comptag='19-D36-29+600' and numero='D19',limite dept 23,laisser en l'état
id_comptag='19-D38-7+0' and numero='D14',RP MAJ a estimation
--UPDATE 6 LE 20240906
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
obs_supl='maj a estimation traf2023,ex '||id_comptag||' traf2022'
where id_ign in ('TRONROUT0000000097420226','TRONROUT0000000097420202','TRONROUT0000000097420224','TRONROUT0000000097420213','TRONROUT0000000097420225','TRONROUT0000000097420221');

id_comptag='19-D940-34+260' and numero='D940E4',,RP MAJ a estimation
--UPDATE 4 LE 20240906
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
obs_supl='maj a estimation traf2023,ex '||id_comptag||' traf2022'
where id_ign in ('TRONROUT0000000244228946','TRONROUT0000000244228927','TRONROUT0000000244228943','TRONROUT0000000244228947');

id_comptag='19-D940-44+0' and numero is null,laisser en l'état car coquilles IGN sur importance,ajout de troncon a lineariser
--UPDATE 5 LE 20240906
update lineaire.traf2024_bdt19_ed24_l set id_comptag='19-D940-44+0',coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
obs_supl='linearisation etiree traf2023'
where id_ign in ('TRONROUT0000000097353364','TRONROUT0000000097353360','TRONROUT0000000097354833','TRONROUT0000000097354832','TRONROUT0000000097353369');

id_comptag='19-D979-69+0' and numero='D683',maj a estimation,croisement avec importance 3 dont on ne connait pas le trafic

/* ######################################################################
!!!!! Attention : à vérifier si j'ai ce cas : rebascule en estimation !!!! 
######################################################################## */ 

--UPDATE 30 LE 20240906
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
obs_supl='maj a estimation traf2023,ex '||id_comptag||' traf2022'
where array_to_string(id_simpli::text[],',') in in ('279618','279847','280310','280316');

id_comptag='' and numero=''

--ED22
--!!!AUCUNE VERIF NECESSAIRE ED22 CAR numero id_comptag=numero ign

--verif QGIS pour coment_cpt='linearisation'
--MAJ (SI BESOIN)
id_comptag='' and numero=''
--modif lin
--UPDATE LE 202409
update lineaire.traf2024_bdt19_ed24_l  set id_comptag='',
obs_supl='ex '||id_comptag||' traf2021'
where id_ign in ('TRONROUT');

id_comptag='' and numero is null
--MAJ a estimation
--UPDATE  LE 202409
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
obs_supl='maj a estimation traf2022,ex '||id_comptag||' traf2021,ex '||obs_upl
where id_ign in ('TRONROUT');

/*===================
NOUVEAUX POINTS BRIVE
=====================*/
--FAIT ED23,INUTILE ED24
--données récupérées par le bruit
--PT a inserer le 20240918
--donnees sources
C:\Users\vincent.vaillant\Box\OTV\donnees_gestionnaires\Brives\en_cours\hors_convention\trafics brive
select distinct gestionnai from comptage.compteur order by gestionnai;

--pts avec valeur de 2014 : Brives-avenue_ribot-1.5011;45.1647,Brives-avenue_ribot-1.5111;45.1647
--pts avec valeur de 2015 : Brives-avenue_andre_malraux-1.4956;45.1646,Brives-avenue_abbe_jean_alvitre-1.5093;45.1536,19-D59-3+0
--pts avec valeur de 2016 : Brives-138_avenue_Ribot-1.5054;45.1647,Brives-89_avenue_georges_pompidou-1.5463;45.1577,Brives-159_avenue_georges_pompidou-1.5568;45.158

--EXEMPLE DE REQUETE UTILISE
--Brives-
--UPDATE XX LE 20240918
update lineaire.traf2024_bdt19_ed24_l set
src_cpt='otv',coment_cpt='linearisation',obs_tmja=null,obs_pc_pl=null,
ann_pt='2014',ann_pc_pl='2014',tmja=13469,pc_pl=4.9,
id_comptag='Brives-avenue_ribot-1.5111;45.1647',
obs_supl='nouveau point traf2023'
where id_ign in
('TRONROUT','TRONROUT');


/*========================
AMELIORATION LINEARISATION
==========================*/

/* ######################################################################
A CHECKER AVEC LES LIGNES A PARTIR DE 2308 et la photo tableau blanc pour tout les cas
AVEC LA POSSIBILITE D'AVOIR UE CLAUSE WHERE SOIT EN ID_IGN, SOIT EN ID_SIMPLI
######################################################################## */ 


/*SECTIONNEMENT AFFINE*/ --découper une section existante en référencant 2 comptages différents
--id_comptag
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set
id_comptag='',
obs_supl='ex '||id_comptag||' traf2023'
where id_ign in ('TRONROUT');

--id_comptag
--UPDATE  LE 202508
update lineaire.traf2024_bdt19_ed24_l set
id_comptag='',
obs_supl='ex '||id_comptag||' traf2023'
where array_to_string(id_simpli::text[],',') in ('');


/*NOUVEAU POINT*/
--id_comptag
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set
src_cpt='otv',coment_cpt='linearisation',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D',
obs_supl='nouveau point traf2023'
where array_to_string(id_simpli::text[],',') in ('');


/*OUBLI LINEARISATION*/
--id_comptag
--UPDATE  LE 202508
update lineaire.traf2024_bdt19_ed24_l set
src_cpt='otv',coment_cpt='linearisation',obs_tmja=null,obs_pc_pl=null,
id_comptag=''
where id_ign in ('TRONROUT');

/*MAJ A ESTIMATION*/
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
obs_supl='maj a estimation traf2024,ex 19-D traf2023'
where array_to_string(id_simpli::text[],',') in ('');


/*=========================
PTS SANS GEOM DANS DEPT 19
==========================*/
--ed24
--0 rows
--ed23
--0 rows
--ed22
--0 rows
select distinct on (t2.id_comptag) t2.id_comptag,
t3.gestionnai,t3.type_poste,t2.annee,t2.periode,t1.*
from comptage.indic_agrege t1 
join comptage.comptage t2 on t1.id_comptag_uniq=t2.id
join comptage.compteur t3 on t2.id_comptag=t3.id_comptag
where t3.dep='19' and t1.indicateur='tmja' and t3.geom is null
order by t2.id_comptag,t2.annee desc;

/*==================================================
POINTS NON UTILISES TOUJOURS PRESENTS DANS COMPTAGE
===================================================*/
--!!!VERIF DES PTS non utilisés présents dans comptage.comptage
--verif que tous les pts linearisés sont dans comptage.vue_compteur_last_annee_know_tmja_pc_pl

--select '('''||  array_to_string(array(
select t1.id_comptag from
(select distinct id_comptag,ann_pt from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' ) t1
left join comptage.vue_compteur_last_annee_know_tmja_pc_pl t2 on t1.id_comptag=t2.id_comptag
where t2.id_comptag is null
--),''',''') ||''')';
--ed24
--2 pt au 20250818
id_comptag in ('19-D16-32+130','19-D982-27+390')
--ed23
--0 pt au 20240912
--ed22
--au 20240529 1 pts
--id_comptag in ('19-D901-20+0') => remplacer par 19-D901-19+0

--UPDATE LE 202505 (SI BESOIN)
update lineaire.traf2024_bdt19_ed24_l set
id_comptag='19-D',
obs_supl='ex 19-D traf2023'
where id_comptag='19-D';

--PTS transférés dans comptage_asso
--MAJ auto
--UPDATE 140 LE 20250818
update lineaire.traf2024_bdt19_ed24_l t1 set
src_cpt='otv',coment_cpt='linearisation',
id_comptag=t2.id_cpteur_ref,
obs_supl=case when t1.obs_supl is not null and t1.obs_supl like 'ex %' then 'ex '||t1.id_comptag||' traf2023,'||t1.obs_supl
when t1.obs_supl is not null then 'ex '||t1.id_comptag||' traf2023,ex '||t1.obs_supl
else 'ex '||t1.id_comptag||' traf2023' end
from comptage_assoc.compteur t2 
where t1.id_comptag=t2.id_cpteur_asso
and t2.id_cpteur_asso in 
('19-D16-32+130','19-D982-27+390');


/*AUTRE VERIF spatiale si compteur dans emprise du 19*/
--select '('''||  array_to_string(array(
select distinct t1.id_comptag from
(select s1.id_comptag from comptage.compteur s1
join aire.dpt_bdt_na_ed24_s s2 on st_within(s1.geom,s2.geom) where s2.dept='19') t1
join (select id_comptag from comptage.comptage where not_lin_why is null) t2
on t1.id_comptag=t2.id_comptag
left join (select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t3
on t2.id_comptag=t3.id_comptag
where t3.id_comptag is null
--),''',''') ||''')';

--ed24
--46 pts au 20250818
id_comptag in ('19-D10-23+940','19-D10-55+835','19-D10-56+0','19-D100-1+275','19-D1089-105+710','19-D109-30+40','19-D116-10+520','19-D116-2+820',
'19-D13-20+330','19-D13-29+80','19-D13-32+350','19-D133-19+90','19-D135-12+220','19-D135E5-14+850','19-D136E4-1+280','19-D138-8+280','19-D142-3+500',
'19-D148-1+0','19-D16-54+100','19-D167-6+0','19-D169-9+900','19-D170-3+880','19-D171-7+0','19-D18E-0+690','19-D20-20+250','19-D25-0+230','19-D25-5+930',
'19-D27-7+110','19-D32-3+150','19-D34-33+50','19-D36-23+50','19-D53-17+605','19-D53E5-1+480','19-D56E-0+930','19-D6-8+850','19-D60-8+180','19-D63-3+730',
'19-D65-6+625','19-D9-4+760','19-D902-13+340','19-D921-11+560','19-D98E-1+800','19-D991-37+300','LavalSurLuzege-route_de_la_mairie-2.1349;45.2665',
'Lubersac-Rue_du_Verdier-1.4014;45.4378','MoustierVendatour-Route_du_Theil-2.0688;45.3868')


--ed23
--1 pt au 20240912
id_comptag='19-D921-3+760',nouveau point a lineariser
--UPDATE 17 LE 20240912
update lineaire.traf2024_bdt19_ed24_l set
src_cpt='otv',coment_cpt='linearisation',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D921-3+760',
obs_supl='nouveau point traf2023,ex 19-D921-5+0 traf2022'
--where id_ign in ('TRONROUT');
where array_to_string(id_simpli::text[],',') in ('389627','389617');

--ed22
--3 pts au 20240529, nouveau pts ou a transférer dans comptage_assoc ?
id_comptag in ('19-D133-24+217','19-D36-15+452','19-D36-5+294')
--Transfert dans comptage_assoc :
('19-D133-23+500','19-D133-24+217')
('19-D36-12+580','19-D36-15+452')
('19-D36-2+130','19-D36-5+294')


/*==========================================================================
AUTRES VERIF POINT RESTANT DANS SCHEMA COMPTAGE ET NON LINEARISE
============================================================================*/
/*avec vue comptage.vue_compteur_last_annee_know_tmja_pc_pl*/
--!!!attention aux pts dont geom est null
--ed24 : 46 pts
--ed23 : 0 pts
--ed22 : 0 pts
--select '('''||  array_to_string(array(select distinct t1.id_comptag
--select count(distinct t1.id_comptag)
select distinct t1.id_comptag,t1.dep,t1.annee_tmja,t1.not_lin_why,t1.geom
from
(select s1.id_comptag,s2.dep,s1.annee_tmja,s1.not_lin_why,s1.geom from comptage.vue_compteur_last_annee_know_tmja_pc_pl s1
join comptage.compteur s2 on s1.id_comptag=s2.id_comptag 
where s2.dep='19' and s1.not_lin_why is null) t1
left join
(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t2
on t1.id_comptag=t2.id_comptag
where t2.id_comptag is null
order by t1.id_comptag
--),''',''') ||''')';

--ed24 
id_comptag in 
('19-D10-23+940','19-D10-55+835','19-D10-56+0','19-D100-1+275','19-D1089-105+710','19-D109-30+40','19-D116-10+520','19-D116-2+820',
'19-D13-20+330','19-D13-29+80','19-D13-32+350','19-D133-19+90','19-D135-12+220','19-D135E5-14+850','19-D136E4-1+280','19-D138-8+280','19-D142-3+500',
'19-D148-1+0','19-D16-54+100','19-D167-6+0','19-D169-9+900','19-D170-3+880','19-D171-7+0','19-D18E-0+690','19-D20-20+250','19-D25-0+230','19-D25-5+930',
'19-D27-7+110','19-D32-3+150','19-D34-33+50','19-D36-23+50','19-D53-17+605','19-D53E5-1+480','19-D56E-0+930','19-D6-8+850','19-D60-8+180','19-D63-3+730',
'19-D65-6+625','19-D9-4+760','19-D902-13+340','19-D921-11+560','19-D98E-1+800','19-D991-37+300','LavalSurLuzege-route_de_la_mairie-2.1349;45.2665',
'Lubersac-Rue_du_Verdier-1.4014;45.4378','MoustierVendatour-Route_du_Theil-2.0688;45.3868')

/*MAJ AUTO ED24*/
WITH 
--troncons proches a moins de 50m du compteur dun troncon ini
project_cpt as (
select t1.id_comptag,t2.coment_cpt,t2.id,t2.id_ign,t2.id_simpli,t2.numero,t2.importance,t2.nature,t2.nom_coll_g,t1.route,
case when substr(split_part(t1.id_comptag,'-',2),1,1) in ('A','N','D')
--RRN ou RD a forcement un numero
and substr(split_part(t1.id_comptag,'-',2),2,2) ~ '^[0-9]+$'
and substr(t1.id_comptag,1,2) in ('16','17','19','23','24','33','40','47','64','79','86','87'
--dept limitrophes
,'03','32','36','37','46','49','65','82') 
and t2.numero is not null then similarity(t1.route,t2.numero)
when t2.numero is null and t2.nom_coll_g is not null then similarity(upper(t1.route),t2.nom_coll_g)
else null end as sim,
round(st_distance(t1.geom,t2.geom)::numeric,2) as dist
--,t2.imp_sup,t2.imp_sup_src,t2.imp_sup_tgt 
from comptage.compteur t1 join
lineaire.traf2024_bdt19_ed24_l t2
on st_dwithin(t1.geom,t2.geom,50)
--ss selection XXX lignes de depart
where t1.id_comptag in
('19-D10-23+940','19-D10-55+835','19-D10-56+0','19-D100-1+275','19-D1089-105+710','19-D109-30+40','19-D116-10+520','19-D116-2+820',
'19-D13-20+330','19-D13-29+80','19-D13-32+350','19-D133-19+90','19-D135-12+220','19-D135E5-14+850','19-D136E4-1+280','19-D138-8+280','19-D142-3+500',
'19-D148-1+0','19-D16-54+100','19-D167-6+0','19-D169-9+900','19-D170-3+880','19-D171-7+0','19-D18E-0+690','19-D20-20+250','19-D25-0+230','19-D25-5+930',
'19-D27-7+110','19-D32-3+150','19-D34-33+50','19-D36-23+50','19-D53-17+605','19-D53E5-1+480','19-D56E-0+930','19-D6-8+850','19-D60-8+180','19-D63-3+730',
'19-D65-6+625','19-D9-4+760','19-D902-13+340','19-D921-11+560','19-D98E-1+800','19-D991-37+300','LavalSurLuzege-route_de_la_mairie-2.1349;45.2665',
'Lubersac-Rue_du_Verdier-1.4014;45.4378','MoustierVendatour-Route_du_Theil-2.0688;45.3868')
order by t1.id_comptag, dist ASC
)
--select * from project_cpt;--215

--classement selon condition(bretelle,similarite,distance)
,rang as (
select id_comptag,coment_cpt,id,id_ign,id_simpli,numero,nom_coll_g,importance,route,nature,sim,dist,
case when (id_comptag like '%Entree%' or id_comptag like '%Sortie%') and nature='Bretelle'
then dense_rank()over(partition by id_comptag order by dist asc)
when (id_comptag like '%Entree%' or id_comptag like '%Sortie%') and nature <>'Bretelle'
then dense_rank()over(partition by id_comptag order by dist asc)
else dense_rank()over(partition by id_comptag order by coalesce(sim,null,0) desc,dist asc) end as rg
--,imp_sup,imp_sup_src,imp_sup_tgt
from project_cpt
)
--select * from rang;

--choix dun troncon si rang=1
,choix_cpt_tronc as (
select distinct on (id_comptag) id_comptag,coment_cpt,id,id_ign,id_simpli,numero,nom_coll_g,importance,route,nature,sim,dist,rg
from rang order by id_comptag,rg
)

--select * from choix_cpt_tronc order by id_comptag;--executee en 15s
--select * from choix_cpt_tronc where coment_cpt='estimation' and sim is not null and dist <1 order by id_comptag;--executee en 15s
--conditions de validation sim>0.5 and dist <20 apres verif des resulats renvoyés
--select id_comptag,numero,nom_coll_g,sim,dist from choix_cpt_tronc where coment_cpt='estimation' and sim>0.5 and dist <20 order by id_comptag;
--select '('''||  array_to_string(array(select id_comptag from choix_cpt_tronc where coment_cpt='estimation' and sim is not null and dist <1 order by id_comptag),''',''') ||''')';
--test avant update
--XX pts(XX rows) avec dist<1, 41/46 pts (659 rows) avec sim >0.5 and t2.dist <20
--select t1.id_ign,t1.id_simpli,t2.id_comptag,t1.coment_cpt,t1.obs_supl from lineaire.traf2024_bdt19_ed24_l t1 join choix_cpt_tronc t2 on t1.id_simpli=t2.id_simpli
--where t2.coment_cpt='estimation' and t2.sim >0.5 and t2.dist <20 order by t2.id_comptag,t1.id_ign;

--UPDATE 659 LE 20250818
update lineaire.traf2024_bdt19_ed24_l t1 set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag=t2.id_comptag,
obs_supl=case when t1.obs_supl is not null then 'nouveau point traf2024,ex '||t1.obs_supl
else 'nouveau point traf2024' end
from choix_cpt_tronc t2
where t1.id_simpli=t2.id_simpli and t1.coment_cpt='estimation' and
t2.coment_cpt='estimation' 
--and t2.sim is not null and t2.dist<1;--XXX rows
and t2.sim >0.5 and t2.dist <20;--659 rows

--VERIF QGIS ED24
--select distinct id_comptag,obs_supl from lineaire.traf2024_bdt19_ed24_l where obs_supl like 'nouveau point traf2024%';

--VERIF ET MAJ
DALLE NA
825 <--
855 -->

/*MAJ MANO*/
--LINEARISATION ETIREE
--19-D36-23+50
--UPDATE 24 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D36-23+50',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('279556','279809','279890','279889');

--19-D27-7+110
--UPDATE 60 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D27-7+110',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('280048','280509','282066','282311');

--19-D20-20+250
--UPDATE 110 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D20-20+250',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('283601','283405','283395','283390','283079','283212','283379','283583','284521','284871','285080',
'285376','285082','285083','285085','285095');

--19-D6-8+850
--UPDATE 25 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D6-8+850',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('283061','283205','283570');

--19-D135-12+220
--UPDATE 20 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D135-12+220',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('282877');

--19-D991-37+300
--UPDATE 67 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D991-37+300',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('284048','284053','284043','285194','284906');

--19-D16-54+100
--UPDATE 3 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D16-54+100',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('284577');

--19-D142-3+500
--UPDATE 37 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D142-3+500',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('284620','284626','284629','284297');

--19-D32-3+150
--UPDATE 61 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D32-3+150',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('286306','286307','286305','286303','283459');

--19-D32-3+150
--UPDATE 61 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D32-3+150',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('286306','286307','286305','286303','283459');

--19-D9-4+760
--UPDATE 4 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D9-4+760',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('289102');

--19-D34-33+50
--UPDATE 11 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D34-33+50',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('287772');

--19-D170-3+880
--UPDATE 6 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D170-3+880',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('286492');

--19-D65-6+625
--UPDATE 22 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D65-6+625',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('290649','290668');

--19-D13-32+350
--UPDATE 47 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D13-32+350',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('293847','291561','291563','290851','290463','290468','290222');

--19-D10-23+940
--UPDATE 27 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D10-23+940',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('290699','290713','290719','290722');

--19-D13-29+80
--UPDATE 7 LE 20250819
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D13-29+80',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('295006');

--19-D13-20+330
--UPDATE 64 LE 20250819
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D13-20+330',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('295096','295096','295583','295581','295749','295750','295751','296121','296116');

/*MODIF LIN*/
--19-D902-13+340
--UPDATE 24 LE 20250818
update lineaire.traf2024_bdt19_ed24_l t1 set
src_cpt='otv',coment_cpt='linearisation',
id_comptag='19-D902-13+340',
obs_supl=case when t1.obs_supl is not null and t1.obs_supl like 'ex %' then 'ex '||t1.id_comptag||' traf2023,'||t1.obs_supl
when t1.obs_supl is not null then 'ex '||t1.id_comptag||' traf2023,ex '||t1.obs_supl
else 'ex '||t1.id_comptag||' traf2023' end
where t1.id_ign in 
('TRONROUT0000000097334200','TRONROUT0000000097332757','TRONROUT0000002275790791','TRONROUT0000000097332751','TRONROUT0000000097334284',
'TRONROUT0000000097334204','TRONROUT0000000097332752','TRONROUT0000000097332748','TRONROUT0000002010496930','TRONROUT0000002275790795',
'TRONROUT0000000097332760','TRONROUT0000000097334203','TRONROUT0000000097332749','TRONROUT0000000097332750','TRONROUT0000000097334205',
'TRONROUT0000002010496931','TRONROUT0000000097332753','TRONROUT0000000097334269','TRONROUT0000000097332756','TRONROUT0000002010496932',
'TRONROUT0000000097334202','TRONROUT0000000097332755','TRONROUT0000000097334201','TRONROUT0000000097334206');

--19-D25-0+230
--UPDATE 21 LE 20250818
update lineaire.traf2024_bdt19_ed24_l t1 set
src_cpt='otv',coment_cpt='linearisation',
id_comptag='19-D25-0+230',
obs_supl=case when t1.obs_supl is not null and t1.obs_supl like 'ex %' then 'ex '||t1.id_comptag||' traf2023,'||t1.obs_supl
when t1.obs_supl is not null then 'ex '||t1.id_comptag||' traf2023,ex '||t1.obs_supl
else 'ex '||t1.id_comptag||' traf2023' end
where array_to_string(t1.id_simpli::text[],',') in ('289095');

--19-D1089-105+710
--UPDATE 41 LE 20250818
update lineaire.traf2024_bdt19_ed24_l t1 set
src_cpt='otv',coment_cpt='linearisation',
id_comptag='19-D1089-105+710',
obs_supl=case when t1.obs_supl is not null and t1.obs_supl like 'ex %' then 'ex '||t1.id_comptag||' traf2023,'||t1.obs_supl
when t1.obs_supl is not null then 'ex '||t1.id_comptag||' traf2023,ex '||t1.obs_supl
else 'ex '||t1.id_comptag||' traf2023' end
where array_to_string(t1.id_simpli::text[],',') in ('291445','291454','360315');

--19-D921-11+560
--UPDATE 18 LE 20250819
update lineaire.traf2024_bdt19_ed24_l t1 set
src_cpt='otv',coment_cpt='linearisation',
id_comptag='19-D921-11+560',
obs_supl=case when t1.obs_supl is not null and t1.obs_supl like 'ex %' then 'ex '||t1.id_comptag||' traf2023,'||t1.obs_supl
when t1.obs_supl is not null then 'ex '||t1.id_comptag||' traf2023,ex '||t1.obs_supl
else 'ex '||t1.id_comptag||' traf2023' end
where array_to_string(t1.id_simpli::text[],',') in ('293930','294127','294128');

/*MAJ A ESTIMATION*/
--PT suspect :
--19-D100-1+275 : tmja_2024=17, verif GSW et route barré
https://www.google.com/maps/@45.3759037,2.1690943,3a,48.9y,342.21h,87.02t/data=!3m7!1e1!3m5!1s8abGrC_jKBS4ztQGSpcS1w!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D2.976594359417433%26panoid%3D8abGrC_jKBS4ztQGSpcS1w%26yaw%3D342.21048586663784!7i16384!8i8192?entry=ttu&g_ep=EgoyMDI1MDgxMy4wIKXMDSoASAFQAw%3D%3D
https://www.google.com/maps/@45.3828306,2.1633193,3a,42.8y,125.67h,82.63t/data=!3m7!1e1!3m5!1s6iftqjTwjeb4XE9stK3QgQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D7.372330162484374%26panoid%3D6iftqjTwjeb4XE9stK3QgQ%26yaw%3D125.67226867948573!7i16384!8i8192?entry=ttu&g_ep=EgoyMDI1MDgxMy4wIKXMDSoASAFQAw%3D%3D

--UPDATE 36 LE 20250818
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
obs_supl=null
where id_comptag in ('19-D100-1+275');

/*NOUVEAU POINT MANO*/
--19-D53E5-1+480
--UPDATE LE 20250818
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D53E5-1+480',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('287309');

/*====================================
STAT LINEARISATION PAR PT DE COMPTAGE
======================================*/
/*ed24*/
--41 nouvelles sections linéarisées et 236,2 Km linéarisées
select count(distinct id_comptag),round(sum(long_km)::numeric,3) as sum_lg_km from lineaire.traf2024_bdt19_ed24_l where obs_supl like 'nouveau point traf2024%';
select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where obs_supl ='nouveau point traf2024';

--5 sections modifiées
select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where obs_supl like '%ex%traf2023%';

--XX sections étirées
select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where obs_supl='linearisation etiree traf2024';


/*================================
PTS AVEC not_lin_why is not null
================================*/
--pts avec not_lin_why is not null
--ed24 : 0 pt
--ed23 : 0 pt
--ed22 : X pt
select * from comptage.comptage where not_lin_why is not null and
id_comptag in (select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv');


/*autre verif,apres REMAJ des indic,que pt avec not_lin_why soit non utilisé*/
select t1.id_comptag,t1.ann_pt,t2.periode
from
(select distinct id_comptag,ann_pt from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv') t1
join (select id_comptag,annee,periode from comptage.comptage where not_lin_why is not null) t2
on t1.id_comptag=t2.id_comptag and t1.ann_pt=t2.annee;
--ed24 : 0 pts LE 20250821
--ed23 : 0 pts LE 202409
--ed22 : 0 pts LE 20240529
id_comptag,ann_pt,periode

/*=======================================
NOT LIN WHY dans emprise du département
=======================================*/
--select '('''||  array_to_string(array(select distinct t1.id_comptag
--select count(distinct t1.id_comptag) --0
from (select s1.id_comptag from comptage.compteur s1
join aire.dpt_bdt_na_ed24_s s2 on st_within(s1.geom,s2.geom) where s2.dept='19') t1
join (select id_comptag from comptage.comptage where not_lin_why is not null) t2
on t1.id_comptag=t2.id_comptag
--),''',''') ||''')';
--ed24 : 1 pt
--id_comptag in ('19-D100-1+275')
--ed23 : 0 pt
--id_comptag in ('')
--ed22 : X pt
--id_comptag in ('')

--requete pour voir le motif,annee
select distinct t1.id_comptag,t1.type_poste,t2.annee,t2.not_lin_why,t3.definition from
(select s1.id_comptag,s1.type_poste from comptage.compteur s1
join aire.dpt_bdt_na_ed24_s s2 on st_within(s1.geom,s2.geom) where s2.dept='19') t1
join (select id_comptag,annee,not_lin_why from comptage.comptage where not_lin_why is not null) t2
on t1.id_comptag=t2.id_comptag
join comptage.enum_not_lin_why t3
on t2.not_lin_why =t3.code;

--ed24 : 1 pt
id_comptag,type_poste,annee,not_lin_why
"19-D100-1+275"	"tournant"	"2024"	"20"	"trafic suspect"
--ed23: 0 pts
id_comptag,type_poste,annee,not_lin_why
--ed22 : 0 pts
id_comptag,type_poste,annee,not_lin_why

/*=================
PTS AVEC DU TMJO
=================*/
--apres import point sur Brive ?
--XX points surAgglo
select '('''||  array_to_string(array(select distinct on (t2.id_comptag) t2.id_comptag
--select distinct on (t2.id_comptag) t2.id_comptag,t2.annee,t3.gestionnai
from comptage.indic_agrege t1 join comptage.comptage t2 on t1.id_comptag_uniq=t2.id
join comptage.compteur t3 on t2.id_comptag=t3.id_comptag
join(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv') t4
on t3.id_comptag=t4.id_comptag
where t1.indicateur='tmjo'
order by t2.id_comptag,t2.annee
),''',''') ||''')';

id_comptag in ('','','')

--verif si indicateur='tmja' pour ces XX pts, oui pts avec tmjo et tmja
-XX pts
select distinct on (t2.id_comptag) t2.id_comptag,t2.annee,t3.type_poste,t1.*
from comptage.indic_agrege t1 join comptage.comptage t2 on t1.id_comptag_uniq=t2.id
join comptage.compteur t3 on t2.id_comptag=t3.id_comptag
where t1.indicateur='tmja' and
t2.id_comptag in ('')
order by t2.id_comptag,t2.annee::int desc

/*============================
PTS RESTANT DONT ANN_PT=2020
=============================*/

--!!!A REVERIFIER APRES MAJ DES INDICATEURS
select '('''||  array_to_string(array(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where ann_pt='2020' order by id_comptag),''',''') ||''')';
--ed24 : 0 pt
--ed23 : 0 pt
--ed22 : 2 pt le 20240529
id_comptag in ('24-D5E3-10+905','24-D60-6+0')


/*=============================================
PLUSIEURS COMPTEURS SUR MEME SECTIONS HOMOGENES
===============================================*/
/*principe*/
--Verification des compteurs sur même sections homogènes
--En agglo possibilité de laisser ce découpage plus fin surtout si variations de trafics significatives
--Possibité problemes de la section homogene lié à méthode

/*MAJ id_cpt_proch*/
--UPDATE 11250 le 20250818 en 3s pour le 19
update lineaire.traf2024_bdt_na_ed24_l set id_cpt_proch=false where id_cpt_proch is true;

--ed24 : UPDATE 11220 le 20250819 en 4s pour le 19
update lineaire.traf2024_bdt_na_ed24_l t1 set id_cpt_proch=true from 
(select distinct on (s1.id_comptag) s1.id_comptag,s2.id_ign
from comptage.compteur s1 join lineaire.traf2024_bdt_na_ed24_l s2
on s1.id_comptag=s2.id_comptag and st_dwithin(s1.geom,s2.geom,100)
where s2.src_cpt='otv'
order by s1.id_comptag,st_distance(s1.geom,s2.geom) asc) t2
where t1.id_comptag is not null and t1.id_ign=t2.id_ign and t1.id_comptag=t2.id_comptag;


/*requete*/
--201 cpteurs
select count(*) from lineaire.traf2024_bdt_na_ed24_l where dept='19' and id_cpt_proch is true;

select id_ign,id_simpli,id_comptag from lineaire.traf2024_bdt_na_ed24_l where dept='19' and id_cpt_proch is true;

--doublons id_simpli
--ed24 : X rows apres consolildation
--ed24 : 4 rows avant consolildation
SELECT id_ign,id_simpli,id_comptag FROM lineaire.traf2024_bdt_na_ed24_l 
WHERE id_simpli IN (SELECT id_simpli FROM lineaire.traf2024_bdt_na_ed24_l where dept='19' and id_cpt_proch is true 
GROUP BY id_simpli HAVING COUNT(*) > 1)  and dept='19' and id_cpt_proch is true
order by id_simpli asc;

--id_ign,id_simpli,id_comptag
"TRONROUT0000000097334202"	{282625}	"19-D902-13+340" => laisser en l'état car variation de trafic entre les 2 pts
"TRONROUT0000000097332678"	{282625}	"19-D902-9+14"
"TRONROUT0000000097398789"	{292101}	"Brives-138_avenue_Ribot-1.5054;45.1647" =>en agglo,laisser en l'état
"TRONROUT0000000220025154"	{292101}	"Brives-avenue_ribot-1.5111;45.1647"

select id_simpli,'('''||string_agg(distinct id_comptag,''',''') ||''')' as list_id_cpt
--SELECT --id_ign,
id_simpli,id_comptag 
FROM lineaire.traf2024_bdt_na_ed24_l 
WHERE id_simpli IN (SELECT id_simpli FROM lineaire.traf2024_bdt_na_ed24_l where dept='19' and id_cpt_proch is true 
GROUP BY id_simpli HAVING COUNT(*) > 1)
and dept='19' and id_cpt_proch is true
group by id_simpli
order by id_simpli asc;

--ed24 : 4 pts
--apres consolidation,XX sect à conserver
id_simpli,list_id_cpt
{282625}	"('19-D902-13+340','19-D902-9+14')"
{292101}	"('Brives-138_avenue_Ribot-1.5054;45.1647','Brives-avenue_ribot-1.5111;45.1647')"


/*================================================================================
MAJ indic à partir de la table comptage.vue_compteur_last_annee_know_tmja_pc_pl
================================================================================*/
--!!!STAT pour traf2024
--nb de points avec valeur ann_n
--132 pts le 20250822,132 pts le 20250821,129 pts le 20250819
--76 pts le 20240918 (ed23)
--79 pts le 20240529 (ed22)
--select count(*) from comptage.vue_compteur_last_annee_know_tmja_pc_pl where annee_tmja='2023';
select count(*) from comptage.vue_compteur_last_annee_know_tmja_pc_pl where annee_tmja='2023' and id_comptag in 
(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null);
--autre requete par jointure plus performante
select count(*) from
(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t1
join (select id_comptag from comptage.comptage where annee='2024') t2
on t1.id_comptag=t2.id_comptag;


--suspect
--ed24 : 1 pts puis 0 pts
--ed23 : 2 pt
--select '('''||  array_to_string(array(select t1.id_comptag from
select count(*) from
(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t1
join (select id_comptag from comptage.comptage where annee='2024' and suspect is true) t2
on t1.id_comptag=t2.id_comptag
--),''',''') ||''')';
--ed24 :  id_comptag in ('')
--ed23 : id_comptag in ('19-A20-229+500','19-A20-265+730')

--toutes annees confondues suspect


/*MAJ des indicateurs à NULL*/
--ed24 : 9424 le 20250822,9421 le 20250821,9421 le 20250819
--ed23 : 8174 le 20240919,8001 le 20240918,7933 le 20240912
--ed22 :7956 rows le 20240529
select count(*) from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null;

--ed24 : 9424 le 20250822,9421 le 20250821,9421 le 20250819
--ed23: 7933 le 20240912
--ed22 : 7956 rows le 20240529
select count(*) from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv';

--UPDATE 202508 (apres verif sens)
--UPDATE 202508 (apres consolid comptage/comptage_assoc)
--UPDATE 202508 (apres verif complete vts et ajout qq tronc)
--UPDATE 9424 20250822 (apres verif complete sectionnement et ajout qq tronc)
--UPDATE 9421 20250821 (apres modif pts sur A20 et verif vts )
--UPDATE 9421 20250819 (apres lin nouveau pts CD19 vts et ajout qq tronc)
--UPDATE 8174 le 20240919 (ed23) (apres linearisation 9 pts sur Brive)
--UPDATE 7963 le 20240531 (ed22) (apres verif complete de la linearisation, vts et ajout qq troncons)
update lineaire.traf2024_bdt19_ed24_l set tmja=null,pc_pl=null,pl=null,ann_pt=null,ann_pc_pl=null,tmja_final=null,pl_final=null,veh_km=null,pl_km=null where src_cpt='otv';
--update lineaire.traf2024_bdt19_ed24_l set tmja=null,pc_pl=null,pl=null,ann_pt=null,ann_pc_pl=null,tmja_final=null,pl_final=null,veh_km=null,pl_km=null where id_comptag is not null;
/*MAJ*/
--UPDATE 9424 20250822
--UPDATE 9421 20250821
--UPDATE 9421 20250819 
--UPDATE 8174 le 20240919 (ed23)
--UPDATE 7963 le 20240531 (ed22)
update lineaire.traf2024_bdt19_ed24_l t1 set 
coment_cpt='linearisation',
tmja=t2.tmja,
ann_pt=t2.annee_tmja,
pc_pl=t2.pc_pl,
pl=case when t2.pc_pl=0 then 0::integer when t2.pc_pl<>0 then round(t2.tmja::numeric*(t2.pc_pl/100.0))::integer else null::integer end,
ann_pc_pl=t2.annee_pc_pl,
obs_tmja=null,
obs_pc_pl=case when t2.pc_pl is null then 'auto' else null end
from comptage.vue_compteur_last_annee_know_tmja_pc_pl t2
where t1.id_comptag=t2.id_comptag and t1.src_cpt='otv';


--verif si suspect apres MAJ indic
--ed24 : 1 pts puis 0 pt
--ed23 : 2 pts
--select count(*) from
select t1.id_comptag,t1.ann_pt from 
(select distinct id_comptag,ann_pt from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t1
join (select id_comptag,annee from comptage.comptage where suspect is true) t2
on t1.id_comptag=t2.id_comptag and t1.ann_pt=t2.annee;
--ed24
id_comptag,annee
"19-A20-229+500"	"2023" => en 1ère vérification
--ed23
id_comptag,annee
"19-A20-229+500"	"2023"
"19-A20-265+730"	"2023"
--ed24,verif avec comptage.na_2000_2024_p
select id_comptag,tmja_2024,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018 from comptage.na_2000_2024_p where id_comptag in ('19-A20-229+500');
id_comptag,tmja_2024,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018 
"19-A20-229+500" NULL		15458	25718	24844	26374	26588
--ed23,verif avec comptage.na_2000_2023_p
select id_comptag,tmja_2024,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018 from comptage.na_2000_2023_p where id_comptag in ('19-A20-229+500','19-A20-265+730');
 id_comptag,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018 
"19-A20-229+500"	15458	25718	24844	26374	26588
"19-A20-265+730"	30790	37796	36532		38128

--verif si not_lin_why apres MAJ indic => not_lin_why rattaché à une annee (exemple ponctuel avec periode estival dernière annéé dispo)
--ed24 : 0 pt
--ed23 : 0 pt
--select count(*) from
select t1.id_comptag,t1.ann_pt,t2.not_lin_why from 
(select distinct id_comptag,ann_pt from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t1
join (select id_comptag,annee,not_lin_why from comptage.comptage where not_lin_why is not null) t2
on t1.id_comptag=t2.id_comptag and t1.ann_pt=t2.annee;
--ed24
id_comptag,annee
--ed23
id_comptag,annee

--verif src_cpt is null and id_comptag is not null
--ed24 : 0 pt le 20250824,0 pt le 20250821,0 pt le 20250818
--ed23 : 0 pt le 20240912
--ed22 : 0 pt le 20240529
select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where src_cpt is null and id_comptag is not null;
select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where src_cpt is null and id_comptag is not null;
--verif qgis
dept='19' and src_cpt is null and id_comptag is not null

--VERIF
--ed24 : 0 row le 20250824,0 row le 20250821,0 row le 20250819
--ed23 : 0 row le 20240912
--ed22 : 0 row le 20240529
select count(*) from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' and tmja is null;

--ed24 : 0 pt le 20250924,0 pt le 20250921,0 pt le 20250918
--ed23 : 0 pt le 20240912
--ed22 : 0 pt le 20240529
--select '('''||  array_to_string(array(
select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' and tmja is null
--),''',''') ||''')';
--id_comptag in ('')

--verif du point concerné
select s2.id_comptag,s3.gestionnai,s3.type_poste,
s2.annee,s2.obs,s2.periode,
s1.valeur,s1.indicateur
from comptage.indic_agrege s1
join comptage.comptage s2 on s1.id_comptag_uniq=s2.id
join comptage.compteur s3 on s2.id_comptag=s3.id_comptag
where s2.id_comptag in ('')
ORDER BY s2.id_comptag,s1.indicateur,s2.annee desc;

--!!!VERIF DES PTS non utilisés présents dans comptage.comptage
--select '('''||  array_to_string(array(
select t1.id_comptag
--,t1.not_lin_why 
from comptage.vue_compteur_last_annee_know_tmja_pc_pl t1
left join 
(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' ) 
t2 on t1.id_comptag=t2.id_comptag
where t1.id_comptag like '19-%'
and t2.id_comptag is null
--and t1.not_lin_why is null
--),''',''') ||''')';

--id_comptag in ('');

--PTS bascules dans comptage asssoc

/*=======================================
MAJ annee anterieur à 2024 et non suspect 
==========================================*/
--ed24 : 1 pt puis 0 pts supect DIRCO
verif avec comptage.na_2000_2024_p
select id_comptag,tmja_2024,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018,pc_pl_2024,pc_pl_2023,pc_pl_2022,pc_pl_2021,pc_pl_2019,pc_pl_2018
from comptage.na_2000_2024_p where id_comptag in ('');
id_comptag,tmja_2024,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018,pc_pl_2024,pc_pl_2023,pc_pl_2022,pc_pl_2021,pc_pl_2019,pc_pl_2018

--ed23: 2 pts suspects DIRCO
verif avec comptage.na_2000_2023_p
select id_comptag,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018,pc_pl_2023,pc_pl_2022,pc_pl_2021,pc_pl_2019,pc_pl_2018
from comptage.na_2000_2023_p where id_comptag in ('19-A20-229+500','19-A20-265+730');
id_comptag,tmja_2023,tmja_2022,tmja_2021,tmja_2019,tmja_2018,pc_pl_2023,pc_pl_2022,pc_pl_2021,pc_pl_2019,pc_pl_2018
"19-A20-229+500"	15458	25718	24844	26374	26588	NULL	18.9	19.4	18.45	18.3
"19-A20-265+730"	30790	37796	36532	NULL	38128	NULL	17.5	18.1	NULL	17.7


/*RAPPEL MAJ ED23*/
--UPDATE 54 LE 20240919
--UPDATE 54 LE 20240918
--UPDATE 54 LE 20240913
update lineaire.traf2024_bdt19_ed24_l t1 set 
ann_pt='2022',ann_pc_pl='2022',
tmja=t2.tmja_2022,pc_pl=t2.pc_pl_2022,pl=round((t2.pc_pl_2022/100.0)*t2.tmja_2022::numeric)::int
from comptage.na_2000_2023_p t2
where t1.id_comptag in ('19-A20-229+500','19-A20-265+730')
and t1.id_comptag=t2.id_comptag;

/*===================================================
Points en dehors du dept mais dans NA et linéarisé
====================================================*/
--!!!REQUETE APPROUVEE pour verif si linearisation avec pt d'un dept limitrophe
select '('''||  array_to_string(array(
select distinct split_part(id_comptag,'-',1) from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null
),''',''') ||''')';

--ed24
('19','24','46','87','Brives','LavalSurLuzege','Lubersac','MoustierVendatour')
--ed23
('19','24','46','87')
--ed22
--('19','24','46','87')

--pts concernés
--select '('''||  array_to_string(array(
select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null and
split_part(id_comptag,'-',1) in ('24','87')
--),''',''') ||''')';
--ed24 : 12 pts
id_comptag in (
'24-A89-166+0',
'24-D5-77+0','24-D5E3-10+905','24-D60-0+700','24-D60-6+0','24-D64-22+630','24-D72-9+810','24-D75-9+325',
'87-A20-222+200',
'87-D18-12+0','87-D43-45+915','87-D7B-40+170')
--ed23 : 11 pts
id_comptag in (
'24-A89-166+0',
'24-D5-77+0','24-D5E3-10+905','24-D60-0+700','24-D60-6+0','24-D64-22+630','24-D72-9+810','24-D75-9+325',
'87-A20-222+200',
'87-D18-12+0','87-D7B-40+170')
--ann_n_1 : 11 pts
id_comptag in (
'24-A89-166+0','24-D5-77+0','24-D5E3-10+905','24-D60-0+700','24-D60-6+0','24-D64-22+630','24-D72-9+810','24-D75-9+325',
'87-A20-222+200',
'87-D18-12+0','87-D7B-40+170')

/*CD24*/
--ed24
--données 2024 déja intégrées dans ORT
--select type_poste from comptage.compteur where
id_comptag in ('24-D5-77+0','24-D5E3-10+905','24-D60-0+700','24-D60-6+0','24-D64-22+630','24-D72-9+810','24-D75-9+325')
cf. données sources : C:\Users\vincent.vaillant\Box\OTV\donnees_gestionnaires\CD24\en_cours
'24-D5-77+0'=> cptge tournant mais aucune valeur 2024
'24-D5E3-10+905'=> cptge tournant mais aucune valeur 2024
'24-D60-0+700'=> cptag ponctuel,pas de nouveau pt ponctuel proche pour 2024
'24-D60-6+0'=> cptge tournant mais aucune valeur 2024
'24-D64-22+630'=> cptag ponctuel,pas de nouveau pt ponctuel proche pour 2024
'24-D72-9+810' => cptge tournant avec valeur 2024, tmja_2024=136,pc_pl_2024=7.97
'24-D75-9+325' => cptge tournant mais aucune valeur 2024

--MAJ ED24
--!!!INUTILE ED24
--MAJ DIRECT SI BESOIN 
--!!!UPDATE X le 202508
update lineaire.traf2024_bdt19_ed24_l set tmja=136,pc_pl=7.97,pl=round((136.0*(7.97/100.0)))::int,ann_pt='2024',ann_pc_pl='2024' where id_comptag='24-D72-9+810';

--ed23
--données 2023 déjà intégrées dans ORT le 20240912
id_comptag in ('24-D5-77+0','24-D5E3-10+905','24-D60-0+700','24-D60-6+0','24-D64-22+630','24-D72-9+810','24-D75-9+325')

/*CD87*/
--ed24
--données 2024 non intégrées dans ORT le 20250819
id_comptag in ('87-D18-12+0','87-D7B-40+170')
--données sources box :C:\Users\vincent.vaillant\Box\OTV\donnees_gestionnaires\CD87\en_cours\2024\20240101-20241231_FIME_SIREDO_H(3).zip
--données sources copiées en local : C:\Users\vincent.vaillant\Desktop\2025\ort\gest\cd87
'87-D18-12+0' => fichier 2024 présent (D0018_PR12+000_H.FIM)
'87-D7B-40+170' => fichier 2024 présent (D0007B_PR40+170_H.FIM)

--ed23
--données 2023 NON intégrées dans ORT le 20240912
id_comptag in ('87-D18-12+0','87-D7B-40+170')
--données sources box :C:\Users\vincent.vaillant\Box\OTV\donnees_gestionnaires\CD87\en_cours\2023
--données sources copiées en local : C:\Users\vincent.vaillant\Desktop\2024\ort\gest\cd87
'87-D18-12+0' => fichier 2023 présent (D0018_PR12+000_H.FIM)
'87-D7B-40+170' => fichier 2023 présent (D0007B_PR40+170_H.FIM)

/*RAPPEL ED21*/
id_comptag in ('24-D5-77+0','24-D5E3-10+905','24-D60-0+700','24-D60-6+0','24-D64-22+630','24-D72-9+810','24-D75-9+325','87-D18-12+0','87-D7B-40+170')
--Verif des pts des gestionnaires non insérés dans l'ORT 2021
'24-D5-77+0'=> aucune valeur 2021
'24-D5E3-10+905'=> aucune valeur 2021
'24-D60-0+700'=>aucune valeur 2021
'24-D60-6+0'=>aucune valeur 2021
'24-D64-22+630'=>aucune valeur 2021
'46-D120-0+0'=> issu de la carto des trafics 2021 du CD46
'87-D18-12+0'=>valeur 2021 (compteur ponctuel) mais uniquement dans fichier FIME et non intégré dans ORT le 20230302
'87-D7B-40+170'=>valeur 2021 (compteur tournant) mais uniquement fichier FIME et non intégré dans ORT le 20230302


/*========================================================================
SYNTHESE NOMBRE DE COMPTEURS LINEARISES PAR ANNEE, PAR GESTIONNAIRE....
===========================================================================*/
select count(distinct id_comptag) as nb_pt,round(sum(long_km)::numeric,2) as sum_lg_km,ann_pt from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv'
group by ann_pt
order by ann_pt::int desc;
--ed24
nb_pt,sum_lg_km,ann_pt
132	1171.30	"2024"
41	305.41	"2023"
19	126.21	"2022"
2	9.89	"2021"
1	27.40	"2019"
2	10.93	"2018"
1	0.32	"2017"
4	13.43	"2016"
3	6.26	"2015"
5	11.69	"2014"
2	4.31	"2013"
1	9.82	"2012"
1	0.32	"2011"

--ed23
nb_pt,sum_lg_km,ann_pt
74	794.12	"2023"
49	361.78	"2022"
22	210.23	"2021"
1	27.40	"2019"
3	16.30	"2018"
3	3.66	"2017"
4	13.43	"2016"
3	6.26	"2015"
5	11.69	"2014"
2	4.31	"2013"
1	9.82	"2012"
1	0.32	"2011"

--ed22
nb_pt,sum_lg_km,ann_pt
79	808.90	"2022"
48	429.62	"2021"
17	138.57	"2019"
5	19.99	"2018"
3	3.66	"2017"
1	9.63	"2016"
3	10.37	"2014"
2	4.31	"2013"
1	9.81	"2012"
1	0.32	"2011"


select '('''||  array_to_string(array(
select distinct split_part(id_comptag,'-',1) as gest from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv'
),''',''') ||''')';
--ed24
('19','24','46','87','Brives','LavalSurLuzege','Lubersac','MoustierVendatour')
--ed23
('19','24','46','87','Brives')
--ed22
--('19','24','46','87')

--nb_pt par gestionnai 
select --t1.id_comptag,t1.ann_pt,t2.gestionnai
count(*) as  nb_pt,t2.gestionnai
from (select distinct id_comptag,ann_pt from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv') t1
join comptage.compteur t2 on t1.id_comptag=t2.id_comptag
group by t2.gestionnai order by nb_pt desc;

--nb_pt,gestionnai
--ed24
172	"CD19"
12	"DIRCO"
9	"ASF"
7	"Brives"
7	"CD24"
3	"CD87"
1	"CD46"
1	"Laval-sur-Luzège"
1	"Lubersac"
1	"Moustier-Vendatour"
--ed23
130	"CD19"
12	"DIRCO"
9	"ASF"
7	"CD24"
7	"Brives"
2	"CD87"
1	"CD46"
--ed22
129	"CD19"
12	"DIRCO"
9	"ASF"
7	"CD24"
2	"CD87"
1	"CD46"

--nb_pt par gestionnai et annee
select s.gestionnai,string_agg(s.ann_pt||':'||s.nb_pt,';') as ann_nb_pt
from (
select 
count(*) as  nb_pt,t2.gestionnai,t1.ann_pt
from (select distinct id_comptag,ann_pt from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv') t1
join comptage.compteur t2 on t1.id_comptag=t2.id_comptag
group by t2.gestionnai,t1.ann_pt order by t2.gestionnai,t1.ann_pt desc
) s
group by s.gestionnai;

gestionnai,ann_nb_pt
--ed24
"ASF"	"2024:9"
"Brives"	"2016:3;2015:2;2014:2"
"CD19"	"2024:106;2023:38;2022:17;2021:1;2018:2;2016:1;2015:1;2014:3;2013:2;2012:1"
"CD24"	"2024:2;2023:1;2022:1;2021:1;2017:1;2011:1"
"CD46"	"2024:1"
"CD87"	"2023:2;2022:1"
"DIRCO"	"2024:11;2019:1"
"Laval-sur-Luzège"	"2024:1"
"Lubersac"	"2024:1"
"Moustier-Vendatour"	"2024:1"
--ed23
"ASF"		"2023:8;2022:1"
"Brives"	"2016:3;2015:2;2014:2"
"CD19"		"2023:57;2022:41;2021:21;2018:3;2016:1;2015:1;2014:3;2013:2;2012:1"
"CD24"		"2023:1;2022:1;2021:1;2017:3;2011:1"
"CD46"		"2022:1"
"CD87"		"2022:2"
"DIRCO"		"2023:8;2022:3;2019:1"
--ed22
"ASF"	"2022:9"
"CD19"	"2022:58;2021:45;2019:15;2018:4;2016:1;2014:3;2013:2;2012:1"
"CD24"	"2022:1;2021:1;2018:1;2017:3;2011:1"
"CD46"	"2022:1"
"CD87"	"2021:2"
"DIRCO"	"2022:10;2019:2"

/*===================================================
VERIF id_comptage compteur et tronc proche linearise
====================================================*/
--proche voisin
WITH
cpt_lin as (
select t1.id_comptag,t1.type_poste,t1.sens_cpt,t1.geom from comptage.compteur t1
join (select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t2
on t1.id_comptag=t2.id_comptag
)

select distinct on (t1.id_comptag) t1.id_comptag,t2.id_comptag,st_distance(t1.geom,t2.geom) as dist,t1.geom
--t1.type_poste,t1.sens_cpt,t1.geom
from cpt_lin t1
join
(select id_comptag,ann_pt,tmja,obs_supl,geom from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t2
on st_dwithin(t1.geom,t2.geom,10)
where t1.id_comptag<>t2.id_comptag
order by t1.id_comptag,st_distance(t1.geom,t2.geom) asc;

--ed24 : 1 pt
id_comptag,id_comptag,dist,geom
"19-D901-48+808"	"19-D901-50+0"	0.25687052004252653	"01010000206A080000621058F9EBB021416666661E8A9E5841"
--ed23 : 1 pt
id_comptag,id_comptag,dist,geom
"19-D901-48+808"	"19-D901-50+0"	0.25687051998202404	"01010000206A080000621058F9EBB021416666661E8A9E5841"
apres verif qgis,laisser en l'état
--ed22 : XX pts

--verif (si besoin)
id_comptag in ('')

/*============================================
VERIF importance in ('1','2') toujours estimee
=============================================*/
--!!!uniquement importance='2' encore estimee
select count(*) as cnt,round(sum(long_km::numeric),2) as sum_lg_km,importance,nature,string_agg(distinct coalesce(numero,'null'),',') as list_num
from lineaire.traf2024_bdt19_ed24_l 
--where coment_cpt='estimation' and importance in ('1','2') 
where coment_cpt='estimation' and importance in ('1','2','3') 
group by importance,nature;

cnt,sum_lg_km,importance,list_num
--ed24
21	3.45	"2"	"Bretelle"	"D1089E1,D1089E2,D1089EC3,D1089EC4,D1089EC5,D1089EC6,null"
134	2.09	"2"	"Rond-point"	"D1089,D141,D141E4,D154,D170E2,D2089,D44,D940E4,null"
233	13.86	"2"	"Route à 1 chaussée"	"D1089,D1089E2,D1089EC3,D1089EC4,D141,D141E4,D170E2,D2089,D940E4,D982,null"
103	9.94	"2"	"Route à 2 chaussées"	"D1089,D1120,D2089,D940E4,null"
3	0.40	"3"	"Bretelle"	"D1089EC8,null"
240	3.02	"3"	"Rond-point"	"D13,D137,D14,D158,D16,D17,D171,D19,D20,D2120,D24,D25,D29,D3,D30,D34,D39,D44,D45,D45E1,D53E3,D59,D683,D9,D901,D901E2,D920,D940E4,D991,null"
5682	978.73	"3"	"Route à 1 chaussée"	"D1,D10,D100,D107,D1089E,D1089EC10,D1089EC7,D1089EC8,D1089EC9,D11,D110,D111,D13,D130,D131,D132,D133,D133E3,D135,D137,D139,D14,D142,D147,D148,D15,D152,D154,D154E2,D155,D156E2,D157,D158,D16,D161,D164,D167,D169,D16E3,D16E5,D16E6,D16E7,D17,D170E2,D172,D18,D18E,D19,D2,D20,D20E5,D20E7,D21,D2120,D22E,D24,D25,D25E,D26,D27,D27E2,D29,D3,D30,D30E1,D32,D34,D36,D36E,D38,D39,D3E3,D41,D44,D44E,D45,D45E1,D48,D5,D51,D53,D53E3,D59,D6,D61,D63E1,D683,D7,D70,D71,D75,D76,D8,D803,D9,D901,D901E1,D901E2,D902,D92,D920,D94,D940E1,D940E4,D94E,D978,D979,D979E1,D980,D982,D991,D9E,D9E2,D9E3,null"
39	2.66	"3"	"Route à 2 chaussées"	"D130,D156E2,D16E6,D7,D920,null"
--ed23
21	3.45	"2"	"Bretelle"		"D1089E1,D1089E2,D1089EC3,D1089EC4,D1089EC5,D1089EC6,null"
129	2.00	"2"	"Rond-point"		"D1089,D141,D141E4,D154,D170E2,D2089,D44,D940E4,null"
242	14.00	"2"	"Route à 1 chaussée"	"D1089,D1089E2,D1089EC3,D1089EC4,D141,D141E4,D170E2,D2089,D940E4,D982,null"
103	9.94	"2"	"Route à 2 chaussées"	"D1089,D1120,D2089,D940E4,null"
3	0.40	"3"	"Bretelle"		"D1089EC8,null"
240	3.02	"3"	"Rond-point"		"D13,D137,D14,D158,D16,D17,D171,D19,D20,D2120,D24,D25,D29,D3,D30,D34,D39,D44,D45,D45E1,D53E3,D59,D683,D9,D901,D901E2,D920,D940E4,D991,null"
6565	1149.29	"3"	"Route à 1 chaussée"	"D1,D10,D100,D107,D1089E,D1089EC10,D1089EC7,D1089EC8,D1089EC9,D11,D110,D111,D13,D130,D131,D132,D133,D133E3,D135,D137,D139,D14,D142,D147,D148,D15,D152,D154,D154E2,D155,D156E2,D157,D158,D16,D161,D164,D167,D169,D16E3,D16E5,D16E6,D16E7,D17,D170,D170E2,D172,D18,D18E,D19,D2,D20,D20E5,D20E7,D21,D2120,D22E,D23,D24,D25,D25E,D26,D27,D27E2,D29,D3,D30,D30E1,D32,D34,D36,D36E,D38,D39,D3E3,D41,D44,D44E,D45,D45E1,D48,D5,D51,D53,D53E3,D59,D6,D61,D63E1,D65,D683,D7,D70,D71,D75,D76,D8,D803,D9,D901,D901E1,D901E2,D902,D92,D920,D94,D940E1,D940E4,D94E,D978,D979,D979E1,D980,D982,D991,D9E,D9E2,D9E3,null"
39	2.66	"3"	"Route à 2 chaussées"	"D130,D156E2,D16E6,D7,D920,null"
--ed22
21	3.45	"2"	"Bretelle"		"null"
105	1.57	"2"	"Rond-point"		"D1089,D141,D141E4,D154,D2089,D921,null"
395	29.66	"2"	"Route à 1 chaussée"	"D1089,D1089E2,D141,D141E4,D2089,D9,D921,D940,D940E4,D982,null"
90	8.30	"2"	"Route à 2 chaussées"	"D1089,D1120,D2089,D940E4,null"
13	2.57	"3"	"Bretelle"		"D130,null"
222	2.92	"3"	"Rond-point"		"D13,D133,D137,D158,D16,D16E6,D17,D19,D20,D2120,D24,D25,D29,D3,D30,D34,D39,D45,D45E1,D53E3,D59,D9,D901,D901E2,D920,D982,null"
6584	1149.89	"3"	"Route à 1 chaussée"	"D1,D10,D100,D107,D1089E,D11,D110,D111,D13,D131,D132,D133,D133E3,D135,D137,D139,D14,D142,D147,D148,D15,D152,D154,D154E2,D155,D156E2,D157,D158,D16,D161,D164,D167,D169,D16E3,D16E5,D16E6,D16E7,D17,D170,D170E2,D172,D18,D18E,D19,D2,D20,D20E5,D20E7,D21,D2120,D23,D24,D25,D25E,D26,D27,D27E2,D29,D3,D30,D30E1,D32,D34,D36,D36E,D38,D39,D3E3,D41,D44,D44E,D45,D45E1,D48,D5,D51,D53,D53E3,D59,D6,D61,D63E1,D65,D683,D7,D70,D71,D75,D76,D8,D9,D901,D901E1,D901E2,D902,D92,D920,D94,D940E1,D94E,D978,D979,D979E1,D980,D982,D991,D9E,D9E2,D9E3,null"
14	1.26	"3"	"Route à 2 chaussées"	"D920,D979"

--verif qgis pour (si besoin)
dept='19' and coment_cpt='estimation' and importance='2' and nature='Bretelle' and numero is null

/*=================================================
Pt du RRN avec valeur inférieur à 2024 (ann_pt<2024)
===================================================*/
--select '('''||  array_to_string(array(select distinct id_comptag
select distinct id_comptag,ann_pt,tmja,ann_pc_pl,pc_pl 
from lineaire.traf2024_bdt19_ed24_l where ann_pt::int<2024 and (id_comptag like '%-N%' or id_comptag like '%-A%')
--),''',''') ||''')';

--ed24 : 1 pts
--id_comptag in ('19-A20-240+820')
--id_comptag,ann_pt,tmja,ann_pc_pl,pc_pl
"19-A20-240+820"	"2019"	25091	"2019"	17.9
--ed23 : 3 pts
--id_comptag in ('19-A20-240+820','19-A20-256+820','19-A20-286+0')
id_comptag,ann_pt,tmja,ann_pc_pl,pc_pl
"19-A20-240+820"	"2019"	25091	"2019"	17.9
"19-A20-256+820"	"2022"	33406	"2022"	18.8
"19-A20-286+0"		"2022"	18846	"2019"	16.75 => point DGITIM et données 2023 non récupérées au 20240912

--ed22 : 2 pts
--id_comptag in ('19-A20-240+820','19-A20-271+860')
id_comptag,ann_pt,tmja,ann_pc_pl,pc_pl
"19-A20-240+820"	"2019"	25091	"2019"	17.9
"19-A20-271+860"	"2019"	33358	"2017"	16.2

--verif tableur DIRCO
C:\Users\vincent.vaillant\Box\OTV\donnees_gestionnaires\DIRCO\en_cours
--ed24
"19-A20-240+820" => valeurs vides dans tableur TMJA 2024 DIRCO, pas de données dans tableur TMJM 2024 DIRCO
"19-A20-256+820" => données horaires dispo mais valeurs vides dans tableur TMJA 2024 DIRCO, pas de données dans tableur TMJM 2024 DIRCO
--ed23
"19-A20-240+820" => valeur vide dans tableur TMJA 2023 DIRCO, pas de données dans tableur TMJM 2023 DIRCO
"19-A20-256+820" => valeur vide dans tableur TMJA 2023 DIRCO, pas de données dans tableur TMJM 2023 DIRCO
--ed22
"19-A20-240+820" => station DND double sens, pas de données dans tableur TMJM 2022 DIRCO
"19-A20-271+860" => station DND double sens, pas de données dans tableur TMJM 2022 DIRCO
--ed21
"19-A20-240+820"	"2019"	25091	"2019"	17.9
"19-A20-271+860"	"2019"	33358	"2017"	16.2
"19-A20-283+965"	"2019"	25510	"2019"	18.81
"19-A20-286+0"		"2019"	19131	"2019"	16.75
id_comptag in ('19-A20-240+820','19-A20-271+860','19-A20-283+965','19-A20-286+0')

/*RAPPEL ED21*/
--verif tableur 2021 DIRCO
'19-A20-229+500'=> station DND dans un sens pour 2021, verif si le trafic est symétrique sur cette station
'19-A20-256+820'=> station DND dans un sens pour 2021, verif si le trafic est symétrique sur cette station
'19-A20-265+730'=> station DND dans un sens pour 2021, verif si le trafic est symétrique sur cette station
'19-A20-283+965'=> station DND dans les 2 sens pour 2021

--'19-A20-229+500'=> sens 2 dispo,quasi symetrie des trafic dans tableur 2019 TMJM de la DIRCO
obs='sens 1 DND ; *2'
tmja_2021=select 12422*2;--24844
pc_pl_2021=19.4
--UPDATE 29
update lineaire.traf2021_bdt19_ed21_l set ann_pt='2021',ann_pc_pl='2021',tmja=24844,pc_pl=19.4,pl=round(24844::numeric*(19.4/100.0))::integer where id_comptag='19-A20-229+500';

--'19-A20-256+820'=> sens 1 dispo,quasi symetrie des trafic dans tableur 2018 TMJM de la DIRCO
obs='sens 1 DND ; *2'
tmja_2021=select 15940*2;--31880
pc_pl_2021=19.3
--UPDATE 18
update lineaire.traf2021_bdt19_ed21_l set ann_pt='2021',ann_pc_pl='2021',tmja=31880,pc_pl=19.3,pl=round(31880::numeric*(19.3/100.0))::integer where id_comptag='19-A20-256+820';

--'19-A20-265+730' => sens 1 dispo,verif quasi symetrie des trafic dans tableur 2018 TMJM de la DIRCO
obs='sens 2 DND ; *2'
tmja_2021=select 18266*2;--36532
pc_pl_2021=18.1
--UPDATE 23
update lineaire.traf2021_bdt19_ed21_l set ann_pt='2021',ann_pc_pl='2021',tmja=36532,pc_pl=18.1,pl=round(36532::numeric*(18.1/100.0))::integer where id_comptag='19-A20-265+730';


si besoin verif données sources

/*==========================
VERIF des ratio spécifiques
==========================*/
--!!!utilisation du champs coment_tmj_f 23uis ED21
--A refléchir à l'avenir si ratio spécifiques à conserver sachant que l'importance des bretelles et moindre que la section courante
--prévoir une requete de confrontation entre tmja_veh_sens_db estimé (à divisé par 2,3 ou 4) par aire urbaine avec le tmja_final linéarisé ave ratio

--Valeurs de coment_tmj_f
select '('''||array_to_string(array(
select distinct coment_tmj_f from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv'
order by coment_tmj_f
),''',''')||''')' ;
--ed24
('/12','/15','/2','/3','/30','/4','/6')
--ed23
('/12','/15','/2','/20','/3','/30','/4','/6')
--ed22
('/12','/15','/2','/20','/3','/30','/4','/6')
--ed21
('/12','/15','/2','/20','/3','/30','/4','/6')

--avec coment_tmj_f
--ratio considéré comme particulier
select distinct left(split_part(id_comptag,'-',2),1) as reseau,split_part(coment_tmj_f,'/',2)::int as ratio
from lineaire.traf2024_bdt19_ed24_l
where src_cpt='otv' and split_part(id_comptag,'-',1)  ~ '^[0-9]+$' and coment_tmj_f like '/%'
order by reseau,ratio;

--ed24
reseau,ratio
"A"	2
"A"	6
"A"	12
"A"	15
"A"	30
"D"	2
"D"	3
"D"	4

--ed23
reseau,ratio
"A"	2
"A"	6
"A"	12
"A"	15
"A"	20
"A"	30
"D"	2
"D"	3
"D"	4

--ed22
reseau,ratio
"A"	2
"A"	6
"A"	12
"A"	15
"A"	20
"A"	30
"D"	2
"D"	3
"D"	4

--ed21
reseau,ratio
"A"	2
"A"	6
"A"	12
"A"	15
"A"	20
"A"	30
"D"	2
"D"	3
"D"	4


--verif (si besoin)
id_comptag like '19-D%' and coment_tmj_f='/6'


/*===========================================
RATIO specifique sur RRN et cohérence du sens
=============================================*/
--!!!RAPPEL DES REGLES GENERIQUES APPLIQUEES SELON champs importance et sens
--par le passé,sens ign a pu etre modifié mais pas le ratio spécifique
--coment_tmj in ('/30','/15','/12') apres MAJ coment_tmj in ('/30','/15','/12','/8','/6','/4') pour left(split_part(id_comptag,'-',2),1) in ('A','N')
--REGLES GENERIQUE pour section courante d'importance 1
--pour quelques cas appliquer les meme regle que importance=2
--si bretelle importance='1' and sens in ('Sens direct','Sens inverse')=> coment_tmj='/4'
--si bretelle importance='1' and sens in ('Sens direct','Sens inverse') et si betelle se resépare=> coment_tmj='/8'
--REGLES GENERIQUE pour section courante d'importance 2
--si bretelle importance='2' and sens='Double sens'=> coment_tmj='/6'
--si bretelle importance='2' and sens in ('Sens direct','Sens inverse')=> coment_tmj='/12'
--REGLES GENERIQUE pour section courante d'importance 3
--si bretelle importance='3' and sens='Double sens'=> coment_tmj='/15'
--si bretelle importance='3' and sens in ('Sens direct','Sens inverse')=> coment_tmj='/30'
--!!!pour importance='5' on laisse à estimer

--Avant modification générique,coment_tm_f
select '('''||array_to_string(array(
select distinct coment_tmj_f from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv'
order by coment_tmj_f
),''',''')||''')';
--ed24
--apres MAJ
('/12','/15','/2','/3','/30','/4','/6')
--ed23
--apres MAJ
('/12','/15','/2','/3','/30','/4','/6')
--avant MAJ
('/12','/15','/2','/20','/3','/30','/4','/6')
--ed22
('/12','/15','/2','/20','/3','/30','/4','/6')
--ed21
('/12','/15','/2','/20','/3','/30','/4','/6')


--Rappel
select '('''||  array_to_string(array(
select distinct split_part(id_comptag,'-',1) from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null
),''',''') ||''')';
--ed24
('19','24','46','87','Brives','LavalSurLuzege','Lubersac','MoustierVendatour')
--ed23
('19','24','46','87')
--ed22
--('19','24','46','87')

--verif ed24 (si besoin)

--verif ed23
dept='19' and coment_tmj_f='/20'
--MAJ a coment_tmj_f='/30'
--UPDATE 1 le 20240912
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/30' where coment_tmj_f='/20';

-!!!modif possible d'un millesime à l'autre => changement d'importance surtout
--verif changement imp
--ed24 : 0 rows
--ed23 : 0 rows
--ed22 : 0 rows
select id_ign,id_comptag,nature,numero,importance from lineaire.traf2024_bdt19_ed24_l where left(split_part(id_comptag,'-',2),1) in ('A','N') and attr_modif is not null;
--sans agglo (possilité pt de l'agglo privilégié plutôt que gestionnaire RRN, exemple sur Limoges Métropole)
--ed24 : 0 rows
--ed23 : 0 rows
--ed22 : 0 rows
select id_ign,id_comptag,nature,numero,importance from lineaire.traf2024_bdt19_ed24_l where left(split_part(id_comptag,'-',2),1) in ('A','N') and attr_modif is not null
--and id_comptag not like 'Agglo-%';
--and split_part(id_comptag,'-',1) not in ('Agglo-');
--si tronc,souvent quasi tous avec nature in ('Rond-point','Bretelle')
--verif qgis ann_n
id_ign,id_comptag,nature,numero,importance

--verif tronc recup autre que pk_ign ou ad
--ed24 : 0 rows
--ed23 : 91 rows
--ed22 : 7 rows
select id_ign,id_comptag,recup from lineaire.traf2024_bdt19_ed24_l where left(split_part(id_comptag,'-',2),1) in ('A','N') and recup not in ('pk_ign','ad');
--sans Agglo-
--select '('''||array_to_string(array(
select id_ign
,id_comptag,coalesce(numero,'NULL') as numero,nature,importance,sens,coment_tmj_f,recup 
from lineaire.traf2024_bdt19_ed24_l where left(split_part(id_comptag,'-',2),1) in ('A','N') and recup not in ('pk_ign','ad')
--and id_comptag not like 'Agglo-%'
--),''',''')||''')' ;
--ed24
--ed23
--ed22
id_ign in ('TRONROUT0000002245479476','TRONROUT0000002245479477','TRONROUT0000002275918543','TRONROUT0000002275918542','TRONROUT0000002275918541',
'TRONROUT0000002275470507','TRONROUT0000002275748375')

/*MAJ*/
--ed24
FILTRE QGIS :
dept='19' and left(substr("id_comptag", strpos("id_comptag", '-') + 1), 1) in ('A','N') and recup not in ('pk_ign','ad')

--ed23
FILTRE QGIS :
dept='19' and left(substr("id_comptag", strpos("id_comptag", '-') + 1), 1) in ('A','N') and recup not in ('pk_ign','ad')
--maj
--UPDATE 6 LE 20240912
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/12' where id_ign in ('TRONROUT0000002332339924','TRONROUT0000000097341839','TRONROUT0000002332339926',
'TRONROUT0000000097341854','TRONROUT0000002332339925','TRONROUT0000000097341876');
--UPDATE 13 LE 20240912
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/12' where id_ign in 
('TRONROUT0000002332536006','TRONROUT0000002332536019','TRONROUT0000002332536007','TRONROUT0000000097360807','TRONROUT0000000097360831','TRONROUT0000002332536015',
'TRONROUT0000000097360842','TRONROUT0000002332536017','TRONROUT0000002332536005','TRONROUT0000002332536018','TRONROUT0000000097360843','TRONROUT0000002332536016',
'TRONROUT0000000097360845');
--UPDATE 4 LE 20240912
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/30' where id_ign in 
('TRONROUT0000000097370772','TRONROUT0000002332533756','TRONROUT0000000097372534','TRONROUT0000000097372517');
--UPDATE 2 LE 20240912
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/12' where id_ign in 
('TRONROUT0000000116846707','TRONROUT0000002332339922');
--UPDATE 2 LE 20240912
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/30' where id_ign in 
('TRONROUT0000002332367319','TRONROUT0000000295010931');
--UPDATE 6 LE 20240912
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/30' where id_ign in 
('TRONROUT0000002332367295','TRONROUT0000000220023851','TRONROUT0000002332367297','TRONROUT0000002332367296','TRONROUT0000000097413453','TRONROUT0000000097413398');

--ed22
--APRES VERIF QGIS AUCUNE MAJ NECESSAIRE
--verif qgis ann_n_1
--id_comptag='19-A89-233+0' and recup in ('topo_n','imp')
--ou
-id_comptag='19-A89-233+0' and recup not in ('pk_ign','ad')

/*===========================================================================================
Verif des valeur aberrante en tmja a partir de vue comptage.vue_evolutions_tmja
===========================================================================================*/
--A partir de comptage.vue_evolutions_tmja
--passage en colonne en ligne avec union
--condition que pt soit linearise dans trafANN


--Numéro RNN linéarisé
select '('''||  array_to_string(array(
select distinct numero from lineaire.traf2024_bdt19_ed24_l where cl_admin in ('Autoroute','Nationale')
),''',''') ||''')';
--ed24
--('A20','A89')
--ed23

/*ANN_N*/

WITH 
--comparaison valeur ann_n,ann_n_1,ann_n_2 avec windows fonction lead
ann_n_n_1 as (
select t1.id_comptag,t1.annee as annee_n,t1.tmja as tmja_n,
LEAD(t1.annee)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as annee_n_1,LEAD(t1.annee,2)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as annee_n_2,
LEAD(t1.tmja)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as tmja_n_1,LEAD(t1.tmja,2)OVER (PARTITION BY t1.id_comptag ORDER BY t1.annee::int desc) as tmja_n_2
from comptage.vue_evolutions_tmja t1
join (select distinct id_comptag from lineaire.traf2024_bdt_na_ed24_l where src_cpt='otv') t2 on t1.id_comptag=t2.id_comptag
order by t1.id_comptag,t1.annee::int desc
)
--select * from ann_n_n_1;

/*select distinct on (id_comptag) id_comptag,annee_n,annee_n_1,tmja_n,tmja_n_1, 
(((tmja_n::numeric - tmja_n_1::numeric)/tmja_n_1::numeric)*100::numeric)::numeric(6,2) as evol_n_n_1 
from ann_n_n_1 order by id_comptag,annee_n::int desc;*/

,evol_ann_n_n_1 as (
select distinct on (t1.id_comptag) t1.id_comptag,t2.nb_ann,t1.annee_n,t1.annee_n_1,t1.annee_n_2
,t1.tmja_n,t1.tmja_n_1,t1.tmja_n_2,
t1.tmja_n-t1.tmja_n_1 as diff_n_n_1,
(((t1.tmja_n::numeric - t1.tmja_n_1::numeric)/t1.tmja_n_1::numeric)*100::numeric)::numeric(6,2) as evol_n_n_1
from ann_n_n_1 t1
left join (select id_comptag,count(*) as nb_ann from ann_n_n_1 group by id_comptag) t2 on t1.id_comptag=t2.id_comptag
order by t1.id_comptag,t1.annee_n::int desc
)

--identification des valeurs aberrantes en croisant évolution et difference de tmja, 
--faire varier evolution ou difference si besoin de travailler sur 1 dept specifique
select * from evol_ann_n_n_1
--select * from evol_ann_n_n_1 where id_comptag like '%-A20-%' and annee_n='2024';--evol N10
--SELECT PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY evol_n_n_1) FROM evol_ann_n_n_1 where id_comptag like '%-A20-%' and annee_n='2024' and annee_n_1='2023';-- -1.11% ed24,XX% ed23,X.XC% ed22
--SELECT PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY evol_n_n_1) FROM evol_ann_n_n_1 where id_comptag like '%-A89-%' and annee_n='2024' and annee_n_1='2023';--0.00% ed24,XX% ed23
--SELECT PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY evol_n_n_1) FROM evol_ann_n_n_1 where id_comptag like '19-D%' and annee_n='2024' and annee_n_1='2023';--+1.43% ed24,XX% ed23,X.XX% ed22
--SELECT count(*) as cnt,round(avg(evol_n_n_1)::numeric,2) FROM evol_ann_n_n_1 where id_comptag like '19-D%' and annee_n='2024' and annee_n_1='2023';--ed24:19 pts et +0.38%,ed23:XX pts et X.XX%
--where abs(evol_n_n_1) >30 and abs(diff_n_n_1)>1000
--where abs(evol_n_n_1) >30 and abs(diff_n_n_1)>500
where abs(evol_n_n_1) >20 and abs(diff_n_n_1)>300
--where id_comptag like '19-%' order by annee_n::int desc,abs(diff_n_n_1);
and id_comptag like '19-%' and annee_n='2024' order by abs(diff_n_n_1);
--and id_comptag like 'Agglo-%' and annee_n='2023' order by abs(diff_n_n_1);
--and id_comptag like '19-VC-%' and annee_n='2023' order by abs(diff_n_n_1);

--ann_n,id_comptag like '19-%'
--X pts/7 pour traf2024 avec annee_n='2024' and abs(evol_n_n_2) >20 and abs(diff_n_n_2)>300
--pour id_comptag like '19-%' and annee_n='2024'
id_comptag,nb_ann,annee_n,annee_n_1,annee_n_2,tmja_n,tmja_n_1,tmja_n_2,diff_n_n_1,evol_n_n_1
"19-D17-18+480"	3	"2024"	"2021"	"2018"	3387	2805.0	2868	582.0	20.75
"19-D170-23+0"	7	"2024"	"2023"	"2022"	3340	2710	3359	630	23.25
"19-D44-15+270"	4	"2024"	"2022"	"2018"	3541	2749	2617	792	28.81
"19-D148E1-7+0"	3	"2024"	"2021"	"2017"	1961	2777.0	2825	-816.0	-29.38
"19-D1089-87+106"	7	"2024"	"2023"	"2022"	7486	9559	9880	-2073	-21.69
"19-A20-265+730"	8	"2024"	"2023"	"2022"	37358	30790	37796	6568	21.33
"19-A20-229+500"	11	"2024"	"2023"	"2022"	25860	15458	25718	10402	67.29

--verif
"19-D17-18+480"=> légère augmentation du trafic,laisser en l'état
"19-D170-23+0" => conforme avec valeur n-2
"19-D44-15+270" =>légère augmentation du trafic,laisser en l'état
"19-D148E1-7+0" =>légère baisse du trafic,laisser en l'état
"19-D1089-87+106" => baisee du trafic,laisser en l'état car pas d'explications
"19-A20-265+730" => pb avec annee 2023 (à partir des données horaires)
"19-A20-229+500" => pb avec annee 2023 (à partir des données horaires)

--Observations génériques
"19-D" => lié à déviation de Malemort ouverte en mars 2022 qui permet de contourner Brive
"19-D"	=> valeur antérieure de 2019
"19-D"=> hausse signifiactive alors en moyenne autour de 5000, explication difficile à trouver, lié à des travaux sur A89 qui a entrainé du report de trafic ?

select * from comptage.comptage where id_comptag='19-A20-' and annee='2024';
suspect='true'
obs='données agregees non dispo et plusieurs jours avec des sens assymetrique en volume de trafic'

qualite MS
C:\Users\vincent.vaillant\Box\OTV\travail\2023\Donnees_produites\IntegrationComptage\QualiteParDept\Analyse_Comptages_2024_dept19.xlsx
id_comptag	annee	id_uniq_cpt	natureAnalyseTrafic	tmja	txt_qualite_evolution_trafic	vueEvolution.annee_recent	vueEvolution.tmja_recent	vueEvolution.evol_anuelle	txt_qualite_prevision_trafic
	
--ed24,id_comptag like 'Agglo-%',X pts
--pour traf2023 avec annee_n='2024' and abs(evol_n_n_2) >20 and abs(diff_n_n_2)>300
--pour id_comptag like 'Agglo-%' and annee_n='2023'
id_comptag,nb_ann,annee_n,annee_n_1,annee_n_2,tmja_n,tmja_n_1,tmja_n_2,diff_n_n_1,evol_n_n_1

--!!!cf. fichier d'analyse
\Box\OTV\travail\2022\Donnees_produites\IntegrationComptage\QualitePardept\
verif si meme points qui ressortent en qualité faible
--verif donnée source (si bsesoin)
\Box\OTV\donnees_gestionnaires\


/*RAPPEL ED23*/
--ann_n,id_comptag like '19-%'
--6 pts pour traf2023 avec annee_n='2023' and abs(evol_n_n_2) >20 and abs(diff_n_n_2)>300
--pour id_comptag like '19-%' and annee_n='2023'
id_comptag,nb_ann,annee_n,annee_n_1,annee_n_2,tmja_n,tmja_n_1,tmja_n_2,diff_n_n_1,evol_n_n_1
"19-D152-2+500"		3	"2023"	"2019"	"2016"	3001	2482	2213	519	20.91
"19-D9-34+120"		6	"2023"	"2021"	"2018"	6658	5029.0	4838	1629.0	32.39
"19-D1089-112+0"	7	"2023"	"2022"	"2021"	12116	9308	8270.0	2808	30.17
"19-D1089-113+150"	7	"2023"	"2022"	"2021"	13809	10702	12111.0	3107	29.03
"19-D921-3+760"		2	"2023"	"2022"		8643	4792		3851	80.36
"19-A20-229+500"	10	"2023"	"2022"	"2021"	15458	25718	24844	-10260	-39.89

--verif ED23
19-A20-229+500 => supect=true, reprise tmja_2022 et pc_pl_2022
"19-D921-3+760"	 => obs_2022='deviation ouverte en 2022. Premier trafic complet en 2023'
"19-D1089-112+0" => lié à déviation de Malemort ouverte en mars 2022 qui permet de contourner Brive
"19-D1089-113+150" => lié à déviation de Malemort ouverte en mars 2022 qui permet de contourner Brive
"19-D152-2+500"	=> valeur antérieure de 2019
"19-D9-34+120"=> hausse signifiactive alors en moyenne autour de 5000, explication difficile à trouver, lié à des travaux sur A89 qui a entrainé du report de trafic ?

/*RAPPEL ED22*/
--ann_n_1,id_comptag like '19-%'
--2 pts pour traf2022 avec annee_n='ANN' and abs(evol_n_n_2) >20 and abs(diff_n_n_2)>300
--pour id_comptag like '19-%' and annee_n='2022'
id_comptag,nb_ann,annee_n,annee_n_1,annee_n_2,tmja_n,tmja_n_1,tmja_n_2,diff_n_n_1,evol_n_n_1
"19-D920-46+0"	5	"2022"	"2018"	"2017"	1642	2062	2151	-420	-20.37
"19-D170-23+0"	5	"2022"	"2021"	"2018"	3359	2678.0	3714	681.0	25.43

--ann_n_1,id_comptag like 'Agglo-%',X pts
--pour traf2022 avec annee_n='2022' and abs(evol_n_n_2) >20 and abs(diff_n_n_2)>300
--pour id_comptag like 'Agglo-%' and annee_n='2022'
id_comptag,nb_ann,annee_n,annee_n_1,annee_n_2,tmja_n,tmja_n_1,tmja_n_2,diff_n_n_1,evol_n_n_1


--verif qgis de XX pts
id_comptag in ('')


/*========================================
EVOL ANN_N ENTRE COMPTAGE ET COMPTAGE_ASSO
========================================*/

--!!!evol entre ann_n et ann_n_1 pour les compteurs de traf2019 basculés dans compteur_assoc

WITH pt_ann_n as (
select t1.id_comptag,t1.ann_pt as ann_lin_n_1,t1.tmja as tmja_lin_n_1
from
(select distinct id_comptag,ann_pt,tmja from lineaire.traf2023_bdt_na_ed23_l where dept='19' and id_comptag is not null) t1
left join (select distinct id_comptag from lineaire.traf2024_bdt_na_ed24_l where dept='19' and id_comptag is not null) t2
on t1.id_comptag=t2.id_comptag
where t2.id_comptag is null)
--select * from pt_ann_n;

,pt_ann_n_asso as (
select t2.id_cpteur_asso,t1.ann_lin_n_1,t1.tmja_lin_n_1,t2.type_poste as typ_post_lin_n_1,
t2.id_cpteur_ref from pt_ann_n t1 join comptage_assoc.compteur t2 on t1.id_comptag=t2.id_cpteur_asso
)
--select * from pt_ann_n_asso;
,evol_tmja_n_n_1 as (
select t1.id_cpteur_asso,t1.ann_lin_n_1,t1.tmja_lin_n_1,t1.typ_post_lin_n_1,
t1.id_cpteur_ref,t2.ann_pt as ann_lin_n,t2.tmja as tmja_lin_n,t3.type_poste as typ_post_lin_n,
round(t2.tmja-t1.tmja_lin_n_1) as diff_n_n_1,
round(((t2.tmja-t1.tmja_lin_n_1)::numeric/t1.tmja_lin_n_1::numeric)*100.0,2)as evol_n_n_1
from pt_ann_n_asso t1
join (select distinct id_comptag,ann_pt,tmja from lineaire.traf2024_bdt_na_ed24_l where dept='19' and id_comptag is not null) t2
on t1.id_cpteur_ref=t2.id_comptag
join comptage.compteur t3 on t1.id_cpteur_ref=t3.id_comptag
)
select * from evol_tmja_n_n_1 order by abs(evol_n_n_1) desc;

--ed24
--ann_n : 2 pt
id_cpteur_asso,ann_lin_n_1,tmja_lin_n_1,typ_post_lin_n_1,id_cpteur_ref,ann_lin_n,tmja_lin_n,typ_poste_lin_n,diff_n_n_1,evol_n_n_1
"19-D16-32+130"	"2022"	262	"tournant"	"19-D16-42+425"	"2024"	442	"tournant"	180	68.70
"19-D982-27+390"	"2022"	1896	"tournant"	"19-D982-37+970"	"2024"	2379	"tournant"	483	25.47

--ed23
--ann_n : 0 pt

--verif qgis (si besoin)
--id_comptag in ('')

--ed22
--1 pt
id_cpteur_asso,ann_lin_n_1,tmja_lin_n_1,typ_post_lin_n_1,id_cpteur_ref,ann_lin_n,tmja_lin_n,typ_poste_lin_n,diff_n_n_1,evol_n_n_1
"19-D901-20+0"	"2018"	1831	"tournant"	"19-D901-19+0"	"2022"	2393	"tournant"	562	30.69

--verif qgis (si besoin)
--id_comptag in ('')

verif fichier analyse
\Box\OTV\travail\2024\Donnees_produites\IntegrationComptage\QualitePar23t\

/*========================
VERIF DES PERIODES DU RD
===========================*/

select t1.id_comptag,t1.type_poste,t1.periode
from (select * from comptage.vue_compteur_last_annee_know_tmja_pc_pl where id_comptag like '19-D%') t1
join (select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag like '19-D%') t2
on t1.id_comptag=t2.id_comptag
where t1.type_poste='ponctuel' 
and (t1.periode like '%/07/%' or t1.periode like '%/08/%');

--ed24 : 0 pts
--ed23 : 0 comptages estivaux à verifier
--ed22 : XX comptages estivaux à verifier car pas de comptages ponctuels

--id_comptag in ('')

/*=========================
VERIF DES PERIODES AGGLO
==========================*/
--Rappel
select '('''||  array_to_string(array(
select distinct split_part(id_comptag,'-',1) from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null
),''',''') ||''')';

--ed24
('19','24','46','87','Brives','LavalSurLuzege','Lubersac','MoustierVendatour')
--ed23
('19','24','46','87','Brives')
--ed22
--('19','24','46','87')

--Agglo : Brive
select t1.id_comptag,t1.type_poste,t1.periode
from (select * from comptage.vue_compteur_last_annee_know_tmja_pc_pl where id_comptag like 'Brives-%') t1
join (select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag like 'Brives-%') t2
on t1.id_comptag=t2.id_comptag
where t1.type_poste in ('ponctuel','tournant')
and (t1.periode like '%/07/%' or t1.periode like '%/08/%');

--ed24 : 0 pts
--ed23 : 0 comptages estivaux à verifier
--ed22 : XX comptages estivaux à verifier car tres peu périodes non renseignées

--id_comptag in ('')

*===========================================
VERIF SI ANNEE COMPTAGE_ASSOC > ANNEE COMPTAGE
===============================================*/

--requete de verif
select t1.id_comptag,t2.type_poste,t1.tmja,t1.ann_pt,coalesce(t2.periode,'NULL') as periode,t3.id_cpteur_asso,t3.type_poste,t3.tmja,t3.annee_tmja,coalesce(t3.periode,'NULL') as periode
from (select distinct id_comptag,ann_pt,tmja from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation') t1
join comptage.vue_compteur_last_annee_know_tmja_pc_pl t2 on t1.id_comptag=t2.id_comptag
join comptage_assoc.vue_assoc_compteur_last_annee_know_tmja_pc_pl t3 on t1.id_comptag=t3.id_cpteur_ref
where t3.annee_tmja::int>t1.ann_pt::int
--and t2.type_poste='permanent' and t3.type_poste='tournant' and t3.annee_tmja='ANN';-- pts
--and t2.type_poste='tournant' and t3.type_poste='tournant' and t3.annee_tmja='ANN';-- pt
--and t2.type_poste='ponctuel' and t3.type_poste='ponctuel' and t3.annee_tmja='ANN';-- pts

--ed24 : 0 pts
id_comptag,type_poste,tmja,ann_pt,periode,id_cpteur_asso,type_poste,tmja,annee_tmja,periode

--ed23 : 0 pts
id_comptag,type_poste,tmja,ann_pt,periode,id_cpteur_asso,type_poste,tmja,annee_tmja,periode

--ed22 : X pts

--verif qgis
id_comptag in ('') => motif


/*==============
Compteur et sens
=================*/

--ed24 : 0 compteurs en sens unique
--ed23 : 0 compteurs en sens unique
--ed22 : 0 compteurs en sens unique
select '('''||array_to_string(array(
select t1.id_comptag from (select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t1
join comptage.compteur t2 on t1.id_comptag=t2.id_comptag
where t2.sens_cpt='sens unique'
),''',''')||''')' ;

--ed24 : 0 pts
id_comptag in ('')
--ed23 : 0 pts
id_comptag in ('')
--ed22 : XX pts
id_comptag in (
'19-A20_EntreeSens1-','Agglo-')

/*CAS DES BRETELLES RRN avec compteur*/
--!!!test d'une requete de MAJ généralisable mais non utilisable à cause d'un cas de figure (bretelles qui se dédoublent)
--!!!possibilité plus simple => compteur sont en sens uniques donc identifier simplement bretelles qui se terminent en PO
--MAJ avec requete générique tenant compte sens compteur et sens ign puis simplement MAJ spécifiques par id_ign des bretelles qui se terminent en PO

--ed24 : 0 stations
--ed23 : XX stations
--ed22 : XX stations
select '('''||  array_to_string(array(
select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag like ('19-%Entree%') or id_comptag like ('19-%Sortie%') order by id_comptag
),''',''') ||''')';
--ed24
--ed23
--ed22
('19-A20_EntreeSens1-')


--verif coment_tmj_f cohérent sur les bretelles du RRN dans le 19
--ed24 : 0 rows
--ed23 : X rows
--ed22 : 0 rows
--ed21 : 0  rows
select s.*
from (
select t1.id_ign,t1.id_comptag,t1.sens,t2.sens_cpt,t1.coment_tmj_f,
case when t2.sens_cpt='sens unique' and t1.sens in ('Sens direct','Sens inverse') and t1.coment_tmj_f is null then true
when t2.sens_cpt='sens unique' and t1.sens='Double sens' and t1.coment_tmj_f='*2' then true
when t2.sens_cpt='double sens' and t1.sens='Double sens' and t1.coment_tmj_f is null then true
when t2.sens_cpt='double sens' and t1.sens in ('Sens direct','Sens inverse') and t1.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f,t1.obs_supl
--t1.obs_tmj1,t1.obs_tmj2,
from lineaire.traf2024_bdt19_ed24_l t1
join comptage.compteur t2 on t1.id_comptag=t2.id_comptag
where t1.id_comptag like ('19-%Entree%') or t1.id_comptag like ('19-%Sortie%')
order by t1.id_comptag,t1.id_ign
) s
where s.verif_coment_tmj_f is false;--11 rows


--verif ann_n (si besoin)
--id_comptag in ('19-A20_EntreeSens1-'), id_ign in ('TRONROUT','TRONROUT','TRONROUT')
--verif ann_n_n (si besoin)
id_comptag in ('19-A20_EntreeSens1-')

--Explication ann_n (si besoin)
--'19-A20_EntreeSens1-' =>meme constat ED21, bretelle qui se séparent en 2
--Explication ann_n (si besoin)
--'19-A20_EntreeSens1-' => bretelle qui se séparent en 2 et coment_tmj_f doit etre égale à /2 meme si sens_cpt='sens unique' and sens in ('Sens direct','Sens inverse')
--bien pris en compte dans la requete par id_comptag et troncon ign
--cas de figure difficile à identifier automatiquement (travail linauto sur PO pourrait être utile)


/*==============
Compteur et sens
=================*/
--Rappel
select '('''||  array_to_string(array(
select distinct split_part(id_comptag,'-',1) from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null
),''',''') ||''')';
--ed24
('19','24','46','87','Brives','LavalSurLuzege','Lubersac','MoustierVendatour')
--ed23
--ed22
--('19','24','46','87')

/*verif si sens modifié entre traf_n et traf_n_1 en agglo*/
--ed24 : 0 rows
--ed23 : 0 rows
select s.id_ign,s.dept,s.id_comptag,s.sens_ed_n,s.sens_ed_n_1,
s.coment_tmj_f_ed_n,s.coment_tmj_f_ed_n_1,s.nature_n,s.nature_n_1 from
(
select s1.dept,s1.id,s1.id_ign,s1.id_comptag,
case when s1.sens in ('Sens direct','Sens inverse') then 'Sens unique' else s1.sens end as sens_ed_n,
case when s2.sens in ('Sens direct','Sens inverse') then 'Sens unique' else s2.sens end as sens_ed_n_1,
case when s1.sens='Double sens' and s2.sens in ('Sens direct','Sens inverse') then true
when s1.sens in ('Sens direct','Sens inverse') and s2.sens='Double sens' then true
else null end as modif_sens,
s1.coment_tmj_f as coment_tmj_f_ed_n,s2.coment_tmj_f as coment_tmj_f_ed_n_1,
s1.nature as nature_n,s2.nature as nature_n_1
from lineaire.traf2023_bdt_na_ed23_l s1
join lineaire.traf2021_bdt_na_ed21_l s2 on s1.id_ign=s2.id_ign
where s1.src_cpt in ('otv')
order by s1.id_comptag,s1.id_ign
) s
where s.modif_sens is true
and split_part(s.id_comptag,'-',1) in ('Brive','Tulle');
--and (s.id_comptag like 'Agglo-%');--0 rows

--avec ref.bdt_na_2023_2024_l
--ed24 : 0 rows
--ed23 : X rows
--ed22: X rows
select s.id_ign,s.dept,s.src_cpt,s.id_comptag,s.sens_ed_n,s.sens_ed_n_1,s.recup,
s.coment_tmj_f_ed_n,s.coment_tmj_f_ed_n_1,
s.nature_n,s.nature_n_1
from (
select s1.dept,s1.src_cpt,s1.id,s1.id_ign,s1.id_comptag,s1.recup,
case when s1.sens in ('Sens direct','Sens inverse') then 'Sens unique' else s1.sens end as sens_ed_n,
case when s3.sens in ('Sens direct','Sens inverse') then 'Sens unique' else s3.sens end as sens_ed_n_1,
case when s1.sens='Double sens' and s3.sens in ('Sens direct','Sens inverse') then true
when s1.sens in ('Sens direct','Sens inverse') and s3.sens='Double sens' then true
else null end as modif_sens,
s1.coment_tmj_f as coment_tmj_f_ed_n,s3.coment_tmj_f as coment_tmj_f_ed_n_1,
s1.nature as nature_n,s3.nature as nature_n_1
from lineaire.traf2024_bdt_na_ed24_l s1 join 
(select ss.id ,ss.id_ign,ss.id_propa,null as pk_ign,ss.ad,ss.imp,ss.topo_n,ss.recurs
from (select distinct on (id_ign) id,id_ign,id_propa,ad,imp,topo_n,recurs from ref.bdt_na_2023_2024_l
where sup is null and id_propa is not null and pk_ign is null order by id_ign, topo_n asc,imp asc,recurs asc) ss) s2
on s1.id_ign=s2.id_ign
join lineaire.traf2023_bdt_na_ed23_l s3 on s2.id_propa=s3.id_ign
)s
where s.modif_sens is true and s.recup not in ('ad','pk_ign') and s.src_cpt in ('otv')
--and split_part(s.id_comptag,'-',1) in ('Agglo');--X rows
and (s.id_comptag like 'Brives-%');--X rows

--verif qgis (si besoin)
--recup='topo_n',PO créé
id_comptag='Agglo' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null
--MAJ ann_n_1
--UPDATELE 202508
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_ign in ('TRONROUT');


/*verif champs recup en agglo*/
select split_part(id_comptag,'-',1) as gest,recup,count(*) as cnt from lineaire.traf2024_bdt19_ed24_l 
where split_part(id_comptag,'-',1) in ('Brives')
group by gest,recup;
--ed24
gest,recup,cnt
"Brives"	"pk_ign"	140
--ed23
gest,recup,cnt
"Brives"	"pk_ign"	140
--ed22, pas de pt en agglo
gest,recup,cnt


/*compteurs linearisés en sens unique*/
--ed24 : 0 compteurs
--ed23 : 0 compteurs
--ed22 : 0 compteurs dont XX sur bretelles RRN et XX sur Agglo,cf. bloc requete plus haut
select '('''||array_to_string(array(
select t1.id_comptag from (select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where id_comptag is not null) t1
join comptage.compteur t2 on t1.id_comptag=t2.id_comptag
where t2.sens_cpt='sens unique'
),''',''')||''')' ;

/*tronc proch compteur et sens*/
--ed24 :0 rows
--ed23 :X rows
--ed22 :0 rows
select s.*
from (
select distinct on (t1.id_comptag) t1.id_comptag,t1.obs_supl,t2.dept,t1.gestionnai,t1.type_poste,t1.sens_cpt,t2.id_ign,t2.sens as sens_ign,
t2.coment_tmj_f,t2.nature,
case when t1.sens_cpt='sens unique' and t2.sens in ('Sens direct','Sens inverse') and t2.coment_tmj_f is null then true
when t1.sens_cpt='sens unique' and t2.sens='Double sens' and t2.coment_tmj_f='*2' then true
when t1.sens_cpt='double sens' and t2.sens='Double sens' and t2.coment_tmj_f is null then true
when t1.sens_cpt='double sens' and t2.sens in ('Sens direct','Sens inverse') and t2.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f
from comptage.compteur t1
join lineaire.traf2024_bdt19_ed24_l t2
on t1.id_comptag=t2.id_comptag and st_dwithin(t1.geom,t2.geom,50) --distance large expres comme join par id_comptag aussi
order by t1.id_comptag, st_distance(t1.geom,t2.geom) asc
) s
where s.verif_coment_tmj_f is false;

--verif qgis (si besoin)
id_comptag='Brives-'
Agglo- est un compteur en sens unique
select count(*) as cnt,sens from lineaire.traf2024_bdt19_ed24_l where id_comptag='Brives-' group by sens;
cnt,sens

--MAJ à coment_tmj=null (si besoin)
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f=null where id_comptag='Agglo-'; 


/*requete de verif generique pour avoir coment_tmj_f le plus cohérent sauf sur agglo*/
--RATIO spécifique non considéré
--ed24 : 26 rows
--ed23 : XX rows
--ed22 : 17 rows
--select '('''||array_to_string(array(select s.id_ign
select s.*
from (
select t1.id_ign,t1.id_comptag,t1.sens,t2.sens_cpt,t1.coment_tmj_f,
case when t2.sens_cpt='sens unique' and t1.sens in ('Sens direct','Sens inverse') and t1.coment_tmj_f is null then true
when t2.sens_cpt='sens unique' and t1.sens='Double sens' and t1.coment_tmj_f='*2' then true
when t2.sens_cpt='double sens' and t1.sens='Double sens' and t1.coment_tmj_f is null then true
when t2.sens_cpt='double sens' and t1.sens in ('Sens direct','Sens inverse') and t1.coment_tmj_f='/2' then true
else false end as verif_coment_tmj_f,t1.obs_supl
--t1.obs_tmj1,t1.obs_tmj2,
from lineaire.traf2024_bdt19_ed24_l t1
join comptage.compteur t2 on t1.id_comptag=t2.id_comptag
where 
(coment_tmj_f is null or coment_tmj_f='/2') --on ne verifie pas les ratio specifique /3,/4,/8
--and split_part(t1.id_comptag,'-',1) not in ('Agglo') --on ne verifie pas les agglo
order by t1.id_comptag,t1.id_ign
) s
where s.verif_coment_tmj_f is false --XXX rows puis 0 rows traf_n
--),''',''')||''')' ;

--APRES VERIF QGIS lié à principalement des RP ou PO sur RP créé les années précédentes mais coment_tmj_f non MAJ  ou objets dédoublés
/*ann_n*/
--sens in ('Sens direct','Sens inverse') and coment_tmj_f is null

id_comptag='19-D' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,petit séparateur DBV cree
--UPDATE LE 202505
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

id_comptag='19-D1089-30+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,DBV créé
--UPDATE 4 LE 20250709
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D1089-30+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

id_comptag='19-D921-3+760' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,RP+PO créés
--UPDATE 12 LE 20250709
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D921-3+760' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

id_comptag='19-D921-5+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,PO créé
--UPDATE 2 LE 20250709
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D921-5+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

id_comptag='19-D979-57+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,RP créé
--UPDATE 4 LE 20250709
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D979-57+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

id_comptag='19-D982-27+390' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,PO créé
--UPDATE 2 LE 20250709
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D982-27+390' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;


--sens in ('Double sens') and coment_tmj_f='/2'

id_comptag='19-D' and sens in ('Double sens') and coment_tmj_f='/2',objet fusionné
--UPDATE LE 202507
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f=null where id_comptag='19-D' and sens in ('Double sens') and coment_tmj_f='/2';

id_comptag='19-D18-18+883' and sens in ('Double sens') and coment_tmj_f='/2',laisser en l'état

id_comptag='19-D3-53+0' and sens in ('Double sens') and coment_tmj_f='/2'
--UPDATE 1 LE 202507
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f=null where id_comptag='19-D3-53+0' and sens in ('Double sens') and coment_tmj_f='/2';

/*ED23*/
--sens in ('Sens direct','Sens inverse') and coment_tmj_f is null

id_comptag='19-D1089-22+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,petit séparateur DBV cree
--UPDATE 9 LE 20240524
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D1089-22+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

id_comptag='19-D36-25+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,troncon oublié d'un petit séparateur DBV
--UPDATE 1 LE 20240524
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D36-25+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

id_comptag='19-D921-5+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null,RP créé
--UPDATE 4 LE 20240524
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f='/2' where id_comptag='19-D921-5+0' and sens in ('Sens direct','Sens inverse') and coment_tmj_f is null;

--sens in ('Double sens') and coment_tmj_f='/2'

id_comptag='19-D1089-117+470' and sens in ('Double sens') and coment_tmj_f='/2',objet fusionné
--UPDATE 2 LE 20240524
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f=null where id_comptag='19-D1089-117+470' and sens in ('Double sens') and coment_tmj_f='/2';

id_comptag='19-D1089-70+0' and sens in ('Double sens') and coment_tmj_f='/2',petite coquille
--UPDATE 1 LE 20240524
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f=null where id_comptag='19-D1089-70+0' and sens in ('Double sens') and coment_tmj_f='/2';

/*==========================================================
VERIF ET CONSOLID SECT TRAF2023 (TOUTE ANNEE CONFONDUE)
============================================================*/
/*recup et coment_cpt='linearisation'
select count(*) as cnt,recup from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' group by recup;

cnt,recup*/

--VERIF QGIS
dept='19' and coment_cpt='linearisation' and recup='recurs' => peut être nouveau rond-point créé par exemple
dept='19' and coment_cpt='linearisation' and recup='topo_n' => faire attention si troncon concerné est avant echangeur autoroutier notemment
dept='19' and coment_cpt='linearisation' and recup='imp'

/*Méthode de verif*/
--sous qgis
--anlyse thématique gradué sur lineaire.traf2024_bdt19_ed24_l par id_comptag

--copier coller analyse thématique(utilisation script python pour style ligne vers point) sur vue na_2000_2024_p avec filtre préalable sur les points utilisés pour la linéarisation, puis étiquettes reprendre la couleur de l'objet(@symbol_color)

--Verif possible données 2022 du CD19 en comparant avec CARTO 2022 ou SECTIONNEMENT DU CD19 et verif si possibilité d'étirer
select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and ann_pt='2024' order by id_comptag;
select '('''||array_to_string(array(select distinct id_comptag from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and ann_pt='2023' order by id_comptag),''',''')||''')' ;

--Derniere carte des trafics dispo du CD19
--Carto 2017 du CD19 dispo sur site web de la préfecture
https://www.correze.gouv.fr/Publications/Cartes-et-donnees/Des-cartes-thematiques/Transports-deplacements/ROUTE-Carte-des-trafics-routiers-de-la-Correze-en-2017

--DALLE NA
854 -->
897 <--

REPRENDRE A 897 <--

/* ######################################################################
!!!!! Attention : à vérifier si j'ai ce cas : affectation point existant a un autre point existant !!!! 
######################################################################## */ 
/*MODIF LINEARISATION*/
--REQUETE GENERIQUE
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set
id_comptag='19-D',
obs_supl=case when t1.obs_supl is not null and t1.obs_supl like 'ex %' then 'ex '||t1.id_comptag||' traf2023,'||t1.obs_supl
when t1.obs_supl is not null then 'ex '||t1.id_comptag||' traf2023,ex '||t1.obs_supl
else 'ex '||t1.id_comptag||' traf2023' end
where id_ign in ('TRONROUT');


/* ######################################################################
!!!!! Attention : à vérifier si j'ai ce cas : affectation d'une estimation a un autre point existant !!!! 
######################################################################## */ 
/*PETIT OUBLI*/
--REQUETE GENERIQUE
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set
src_cpt='otv',coment_cpt='linearisation',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D',
obs_supl=null
where id_ign in ('TRONROUT','TRONROUT');

/*LINEARISATION ETIREE*/
--REQUETE GENERIQUE
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set
src_cpt='otv',coment_cpt='linearisation',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D',
obs_supl='linearisation etiree traf2024'
--where id_ign in ('TRONROUT');
where array_to_string(id_simpli::text[],',') in ('');

--19-D27-7+110
--UPDATE 2 LE 20250822
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D27-7+110',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('280510');

--19-D20-20+250
--UPDATE 1 LE 20250822
update lineaire.traf2024_bdt19_ed24_l set coment_cpt='linearisation',src_cpt='otv',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D20-20+250',
obs_supl='nouveau point traf2024'
where array_to_string(id_simpli::text[],',') in ('371041');


/*MAJ A ESTIMATION*/
--REQUETE GENERIQUE
--UPDATE LE 202408
update lineaire.traf2024_bdt19_ed24_l set
src_cpt=null,coment_cpt='estimation',ann_pt=null,ann_pc_pl=null,
id_comptag=null,
id_sect=null,src_sect=null,autor_sect=null,obs_vts=null,id_cpt1=null,
obs_tmja='auto',obs_pc_pl='auto',
obs_supl='maj a estimation traf2024,ex '||id_comptag||' traf2023'
--where id_ign in ('TRONROUT');
where array_to_string(id_simpli::text[],',') in ('');


/*COQUILLE DE LINEARISATION*/
--REQUETE GENERIQUE
--UPDATE LE 202508
update lineaire.traf2024_bdt19_ed24_l set
src_cpt='otv',coment_cpt='linearisation',obs_tmja=null,obs_pc_pl=null,
id_comptag='19-D',
obs_supl=null
where id_ign in ('TRONROUT','TRONROUT');


/*======================================
Maj tmja_final,pl_final,veh_km et pl_km
=======================================*/
--!!!!UTILISATION DU champs coment_tmj_f pour maj de ces champs
--valeur coment_tmj_f,apres consolidation des ratio specifiques sur bretelles
select array_to_string(array(select distinct coalesce(coment_tmj_f,'NULL') from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv'),''',''');
--ed24
/12','/15','/2','/3','/30','/4','/6','NULL
--ed23
/12','/15','/2','/3','/30','/4','/6','NULL
--ed22
/12','/15','/2','/20','/3','/30','/4','/6','NULL
--ed21
/12','/15','/2','/20','/3','/30','/4','/6','NULL

--MAJ tmja_final à partir de coment_tmj_f
--UPDATE 9424 le 20250822
--UPDATE 9421 le 20250821
--UPDATE 8174 le 20240919 (ed23)
--UPDATE 7963 le 20240531 (ed22)
update lineaire.traf2024_bdt19_ed24_l set
tmja_final=case when coment_tmj_f is null then round(tmja::numeric)::integer
when coment_tmj_f='*2' then round(tmja::numeric*2.0)::integer
when coment_tmj_f like '/%' and tmja<>0 then round(tmja::numeric/split_part(coment_tmj_f,'/',2)::numeric)::integer
else null::integer end
where coment_cpt='linearisation';

--ed24 : 0 rows le 20250822,0 rows le 20250821
--ed23 : 0 rows le 20240919
--ed22 : 0 rows le 20240529
select count(*) from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' and tmja_final is null;

--MAJ pl_final
--UPDATE 9363 le 20250822
--UPDATE 9360 le 20250821
--UPDATE 8114 le 20240919 (ed23)
--UPDATE 7903 le 20240531 (ed22)
update lineaire.traf2024_bdt19_ed24_l set
pl_final=case when coment_tmj_f is null and pl=0 then 0::integer
when coment_tmj_f is null and pl<>0 then round(pl::numeric)::integer
when coment_tmj_f='*2' and pl=0 then 0::integer
when coment_tmj_f='*2' and pl<>0 then round(pl::numeric*2.0)::integer
when coment_tmj_f like '/%' and pl=0 then 0::integer
when coment_tmj_f like '/%' and pl<>0 then round(pl::numeric/split_part(coment_tmj_f,'/',2)::numeric)::integer
else null::integer end
where coment_cpt='linearisation' and pl is not null;

--MAJ veh_km
--UPDATE 9424 le 20250822
--UPDATE 9421 le 20250821
--UPDATE 8174 le 20240919 (ed23)
--UPDATE 7963 le 20240531 (ed22)
update lineaire.traf2024_bdt19_ed24_l set veh_km=tmja_final*long_km where coment_cpt='linearisation';

--MAJ pl_km
--UPDATE 9363 le 20250822
--UPDATE 9360 le 20250821
--UPDATE 8114 le 20240919 (ed23)
--UPDATE 7903 le 20240531 (ed22)
update lineaire.traf2024_bdt19_ed24_l set pl_km=pl_final*long_km where coment_cpt='linearisation' and pl is not null;

--tmja et tmja_final null
--ed24 : 0 rows le 20250822,0 rows le 20250821
select count(*) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and tmja is null;
--ed24 : 0 rows le 20250822,0 rows le 20250821
select count(*) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and tmja_final is null;

--pc_pl_null
--ed24 : 61 rows le 20250822,61 rows le 20250821
--ed23 : 60 rows le 20240919,60 rows le 20240918,60 rows le 20240913
--ed22 : 60 rows le 20240529 et XXXX le 202405
--ed21 : XXX le 202305
select count(*) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and pc_pl is null;

--ed24 : 1 pt le 20250822,1 pt le 20250821
--ed23 : 1 pt le 20240919,1 pt le 20240918,1 pt le 20240913
--ed22, 1 pts le 20240529,XX pts le 202405
--ed21,XX pts le 202305
select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and pc_pl is null;

--pts sans valeur de pc_cpl
select '('''||array_to_string(array(select distinct id_comptag 
from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and pc_pl is null order by id_comptag
),''',''')||''')' ;
--ed24
('19-D31-7+500')
--ed23
('19-D31-7+500')
--ed22
--('19-D31-7+500')

--id_comptag in ()
select '('''||  array_to_string(array(
select distinct split_part(id_comptag,'-',1) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and pc_pl is null
),''',''') ||''')';
--ed24
('19')
--ed23
('19')
--ed22
('')
--ed21
--('')

select count(distinct id_comptag) as cnt_cpt,split_part(id_comptag,'-',1) as gest from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and pc_pl is null group by gest;
cnt_cpt,gest
--ed24
1	"19"
--ed23
1	"19"
--ed22
--ed21

--apres verif => comptage tournant du CD19 n'ont pas de pc_pl

--reverif dans comptage.indic_agrege, aucun point
select t2.id_comptag,t2.annee,t3.type_poste,t1.* from comptage.indic_agrege t1 
join comptage.comptage t2 on t1.id_comptag_uniq=t2.id
join comptage.compteur t3 on t2.id_comptag=t3.id_comptag
where t2.id_comptag in ('');

id_comptag,annee,type_poste,id,id_comptag_uniq,indicateur,valeur,fichier

/*===============
champs coment_cpt 
===============*/
--UPDATE 59765 le 20250822
--UPDATE 59754 le 20250821
--UPDATE 59608 le 20240919 (ed23)
--UPDATE 59494 le 20240531 (ed22)
update lineaire.traf2024_bdt19_ed24_l set coment_cpt=
case when src_cpt ='otv' then 'linearisation' else 'estimation' end;

/*===========================================
MAJ coment_tmj_f pour coment_cpt='estimation'
============================================*/
--!!!SI BESOIN DEPUIS traf2022 car directement appliqué apres la creation de la table des trafic suite a transfert de millesime
--pour coment_cpt='estimation' on ne se préoccupe pas des potentiels erreurs sur l'attribut sens

--pour coment_cpt='estimation' on ne se préoccupe pas des potentiels erreurs sur l'attribut sens
--UPDATE 50341 le 20250824
--UPDATE 50333 le 20250821
--UPDATE 51434 le 20240919 (ed23)
--UPDATE 51531 le 20240531 (ed22)
update lineaire.traf2024_bdt19_ed24_l set coment_tmj_f=case when sens='Double sens' then null when
sens in ('Sens direct','Sens inverse') then '/2' else null end
where coment_cpt='estimation' and src_cpt is null;

/*====
STAT
=====*/
select round(sum(long_km)::numeric,2)  as long_tot,
(select round(sum(long_km)::numeric,2)  from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation') as long_lin,
--round(sum(veh_km)::numeric,2)  as veh_km_tot,
--(select round(sum(veh_km)::numeric,2) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation') as veh_km_lin,
(select round(sum(long_km)::numeric,2)  from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' and ann_pt='2024') as long_lin_pt_ann_n,
(select round(sum(long_km)::numeric,2)  from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' and ann_pt::int<2024) as long_lin_pt_inf_ann_n,
(select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv') as compteur_otv,
(select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' and ann_pt='2024') as compteur_otv_pt_ann_n,
(select count(distinct id_comptag) from lineaire.traf2024_bdt19_ed24_l where src_cpt='otv' and ann_pt::int<2024) as compteur_otv_pt_inf_ann_n,
(((select sum(long_km) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation')/sum(long_km))*100)::numeric(5,2) as prc_lin_tot,
(((select sum(long_km) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and ann_pt='2024')/sum(long_km))*100)::numeric(5,2) as prc_lin_ann_n,
(((select sum(long_km) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation' and ann_pt='2024')/
(select sum(long_km) from lineaire.traf2024_bdt19_ed24_l where coment_cpt='linearisation'))*100)::numeric(5,2) as lin_ann_n_lin_tot
from lineaire.traf2024_bdt19_ed24_l;

--stat ann_n (sans MAJ des indic pour ann_n)
long_tot   long_lin_complet      long_lin_pt_ann_n   long_lin_pt_inf_ann_n  compteur_otv   compteur_otv_ann_n   compteur_otv_inf_ann_n   prc_lin_tot   prc_lin_ann_n	lin_ann_n_lin_tot		
XXXX.XX		XXXX.XX			NULL		XXXX.XX			XXX		0			XXX			XX.XX		NULL	NULL	
10620.05		1461.11			NULL				1459.30				169				0				168				13.76	NULL				NULL	

--stat ann_n (apres MAJ des indic pour ann_n)
long_tot   long_lin_complet      long_lin_pt_ann_n   long_lin_pt_inf_ann_n  compteur_otv   compteur_otv_ann_n   compteur_otv_inf_ann_n   prc_lin_tot   prc_lin_ann_n	lin_ann_n_lin_tot
10621.06		1697.30			1171.30			526.00				214				132				82				15.98		11.03		69.01

--stat ann_n (apres consolid lin et verif sectionnement et ajout de troncons)
long_tot   long_lin_complet      long_lin_pt_ann_n   long_lin_pt_inf_ann_n  compteur_otv   compteur_otv_ann_n   compteur_otv_inf_ann_n   prc_lin_tot   prc_lin_ann_n	lin_ann_n_lin_tot
10621.78	1698.03				1172.03			526.00				214				132				82				15.99		11.03		69.02

--stat ann_n apres lin Brive
long_tot   long_lin_complet      long_lin_pt_ann_n   long_lin_pt_inf_ann_n  compteur_otv   compteur_otv_ann_n   compteur_otv_inf_ann_n   prc_lin_tot   prc_lin_ann_n	lin_ann_n_lin_tot

	
--stat ann_n apres verif vits et ajout quelques troncons
long_tot   long_lin_complet      long_lin_pt_ann_n   long_lin_pt_inf_ann_n  compteur_otv   compteur_otv_ann_n   compteur_otv_inf_ann_n   prc_lin_tot   prc_lin_ann_n	lin_ann_n_lin_tot

--ed23
--stat ann_n
long_tot   long_lin_complet      long_lin_pt_ann_n   long_lin_pt_inf_ann_n  compteur_otv   compteur_otv_ann_n   compteur_otv_inf_ann_n   prc_lin_tot   prc_lin_ann_n	lin_ann_n_lin_tot
10615.73	1459.32			794.12		665.20			168		74			94			13.75		7.48	54.42

--ed22
long_tot   long_lin_complet      long_lin_pt_ann_n   long_lin_pt_inf_ann_n  compteur_otv   compteur_otv_ann_n   compteur_otv_inf_ann_n   prc_lin_tot   prc_lin_ann_n	lin_ann_n_lin_tot
10608.64	1436.74			810.46		626.27			160		79		81				13.54	7.64			56.41

--ed21
long_tot   long_lin_complet   long_lin_otv   long_lin_pt2021   long_lin_pt_inf2021   compteur_otv   compteur_otv_pt2021   compteur_otv_inf2021   prc_lin_tot   prc_lin_2021
10595.54	1434.22		897.35		536.87		159			79		80			13.54			8.47	62.57


/*===============================
SAUVEGARDE des tables si besoin
=================================*/
cd C:\Program Files\QGIS 3.34\bin
ogr2ogr -progress -overwrite -f "ESRI Shapefile" -overwrite "R:\\2025\\ort\\sav\\traf2024_bdt19_ed24_l_v202508.shp" ^
PG:"host=localhos user=postgres port=5432 dbname=otv  password=postgre tables=lineaire.traf2024_bdt19_ed24_l"


