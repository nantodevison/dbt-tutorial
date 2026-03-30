"""Regroupe les 84 fichiers macro individuels en 4 fichiers thématiques.

Sans impact sur le comportement dbt : les noms de macros restent identiques.
"""

from pathlib import Path

MACROS_DIR = Path(__file__).parent / 'macros'

# ── Définition des 4 groupes ──────────────────────────────────────────────

GROUPS: dict[str, list[str]] = {
    # Fichier 1 : racine + before_update_affectation_mano
    'mcr_before_update_affectation.sql': [
        'mcr_xx_aj_tronc_nouv_mill',
        'mcr_1_creer_vue_dept_annee',
        'mcr_2a_vrf_attr_modif_bdt_lin',
        'mcr_2b_vrf_dept_limitr_lin',
        'mcr_2e_cmp_gest_bdt_lin',
        'mcr_xx_vrf_gest_bdt_lin',
        'mcr_2f_vrf_nature_bdt_lin',
        'mcr_2g_vrf_nbpt_lgkm_lin',
        'mcr_2h_vrf_pt_linear_absent_cptg_lin',
        'mcr_2i_vrf_pt_sans_geom_lin',
        'mcr_3a_vrf_cptg_limitr_lin',
        'mcr_3b_maj_pt_linear_devenu_assoc_lin',
        'mcr_4a_vrf_pt_attr_dept_non_linear_lin',
        'mcr_4b_vrf_pt_emprise_dept_non_linear_lin',
        'mcr_6_maj_auto_pt_non_linear_lin',
        'cte1_mcr_6_maj_auto_pt_non_linear_lin__choix_cpt_tronc',
        'cte2_mcr_6_maj_auto_pt_non_linear_lin__project_cpt',
        'cte3_mcr_6_maj_auto_pt_non_linear_lin__rang',
        'mcr_23a_vue_lin_finale',
        'mcr_23b_stats_linear',
    ],

    # Fichier 2 : update_affectation_mano + post_update_affectation_mano
    'mcr_update_affectation.sql': [
        'mcr_7_maj_nouv_point_lin',
        'mcr_8_maj_modif_linear_lin',
        'mcr_9_maj_oubli_erreur_lin',
        'mcr_10_maj_etirer_lin',
        'mcr_11_maj_vers_estim_lin',
        'mcr_18a_maj_tmja_final_lin',
        'mcr_19_maj_veh_km_lin',
        'mcr_20_maj_pl_final_pl_km_lin',
        'mcr_21a_maj_cmt_cpt_lin',
        'mcr_22_maj_cmt_tmj_f_estim_lin',
    ],

    # Fichier 3 : calculs_trafic + verifs
    'mcr_calculs_trafic.sql': [
        'mcr_12a_vrf_ann_pt_2020_lin',
        'mcr_12b_vrf_cpt_mm_sect_homo_lin',
        'cte1_mcr_12b_vrf_cpt_mm_sect_homo_lin__linear_tot',
        'cte1_mcr_13a_vrf_cpt_mm_sect_homo_lin__cpt_proche',
        'mcr_12c_vrf_cptg_not_lin_why_geom_dept_lin',
        'mcr_12d_vrf_nb_cpt_ann_n_lin',
        'mcr_12e_vrf_nb_tronc_linear_lin',
        'mcr_12f_vrf_not_lin_why_lin',
        'mcr_12g_vrf_stats_linear_pt_cptg_lin',
        'mcr_12h_vrf_tmjo_lin',
        'mcr_12i_maj_indic_traf_lin',
        'mcr_13b_vrf_tmjo_exists_tmja_lin',
        'mcr_14a_vrf_stats_linear_nbpt_gest',
        'mcr_14b_vrf_stats_linear_gests_annees',
        'mcr_14c_vrf_stats_linear_nbpt_lgkm_annee',
        'mcr_14d_vrf_indic_agrege_after_maj_lin',
        'mcr_18b_vrf_id_cptg_mill_en_cours_lin',
        'mcr_18c_vrf_recup_linear_lin',
        'mcr_21b_vrf_pc_pl_after_maj_final_lin',
        'mcr_21c_vrf_pc_pl_after_maj_group_gest_lin',
    ],

    # Fichier 4 : commentaires_tmja_f + cte + verifs
    'mcr_commentaires_tmja_f.sql': [
        'mcr_13c_maj_cpt_hors_dept_dans_na_lin',
        'cte1_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__auto',
        'cte2_mcr_13c_vrf_cpt_hors_dept_dans_na_lin__list_cpt',
        'mcr_13d_vrf_suspect_indic_lin',
        'cte1_mcr_13d_vrf_histo_traf_lin',
        'mcr_13e_vrf_split_id_cptg_lin',
        'mcr_14e_maj_cmt_tmj_f_itself_lin',
        'mcr_14f_vrf_annee_rrn_pas_dispo',
        'mcr_14g_vrf_coher_cptg_std_vs_linear_lin',
        'cte1_mcr_14g_vrf_coher_cpt_std_lin__cpt_lin',
        'mcr_14h_vrf_cmt_tmj_f_reseau_ratio_lin',
        'mcr_14j_vrf_stats_importance_nature_estim_lin',
        'mcr_xx_maj_cmt_tmj_f_with_ids',
        'mcr_15b_vrf_cmt_tmj_f_attr_modif',
        'mcr_15c_vrf_cmt_tmj_f_recup',
        'mcr_15d_vrf_numero_rrn_lin',
        'mcr_15e_vrf_val_aberr_tmja',
        'cte1_mcr_15e_vrf_val_aberr_tmja__ann_n_n_1',
        'cte2_mcr_15e_vrf_val_aberr_tmja__evo_ann_n_n_1',
        'mcr_16b_vrf_periode_lin',
        'mcr_16c_vrf_ann_cptgassoc_cptgref_lin',
        'mcr_16e_vrf_evo_cpt_dev_assoc_lin',
        'cte1_mcr_16e_vrf_evo_cpt_dev_assoc__pt_ann_n_asso',
        'cte2_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n',
        'cte3_mcr_16e_vrf_evo_cpt_dev_assoc__id_cptg_n_1',
        'cte4_mcr_16e_vrf_evo_cpt_dev_assoc__pt_ann_n',
        'mcr_16f_vrf_sens_agglo_lin',
        'mcr_16g_vrf_sens_bret_rrn_lin',
        'mcr_xx_vrf_cmt_tmj_f_val_lin',
        'mcr_xx_vrf_cptg_sens_unique_lin',
        'mcr_17a_maj_cmt_tmj_f_sens_lin',
        'mcr_17d_vrf_recup_agglo_lin',
        'mcr_17e_vrf_sens_cmt_tmj_f_h_agglo_lin',
        'mcr_17f_vrf_sens_tronc_proche_cpt_lin',
    ],
}

SEPARATOR = '\n\n{# ─────────────────────────────────────────────────────────── #}\n\n'


def main():
    # ── Vérification : chaque macro source doit exister ──
    all_macros = [m for macros in GROUPS.values() for m in macros]
    missing = [m for m in all_macros if not (MACROS_DIR / f'{m}.sql').exists()]
    if missing:
        print(f"ERREUR : fichiers source manquants :\n  " + "\n  ".join(missing))
        return

    # ── Vérification : on couvre bien tous les fichiers .sql sauf schema_macro.yml ──
    existing_sql = {p.stem for p in MACROS_DIR.glob('*.sql')}
    covered = set(all_macros)
    not_covered = existing_sql - covered
    if not_covered:
        print(f"ATTENTION : macros non couvertes par le regroupement :\n  " + "\n  ".join(sorted(not_covered)))
        return

    duplicates = [m for m in all_macros if all_macros.count(m) > 1]
    if duplicates:
        print(f"ERREUR : macros en double :\n  " + "\n  ".join(set(duplicates)))
        return

    print(f"Vérifications OK : {len(all_macros)} macros dans {len(GROUPS)} groupes")

    # ── Création des 4 fichiers regroupés ──
    for group_file, macro_list in GROUPS.items():
        parts = []
        for macro_name in macro_list:
            src = MACROS_DIR / f'{macro_name}.sql'
            content = src.read_text(encoding='utf-8').rstrip()
            parts.append(content)

        combined = SEPARATOR.join(parts) + '\n'
        dest = MACROS_DIR / group_file
        dest.write_text(combined, encoding='utf-8')
        print(f"  Créé : {group_file} ({len(macro_list)} macros)")

    # ── Suppression des 84 fichiers individuels ──
    deleted = 0
    for macro_name in all_macros:
        src = MACROS_DIR / f'{macro_name}.sql'
        src.unlink()
        deleted += 1
    print(f"\n  Supprimé : {deleted} fichiers individuels")

    # ── Résumé ──
    remaining = list(MACROS_DIR.glob('*.sql'))
    print(f"\nRésultat : {len(remaining)} fichiers .sql dans macros/")
    for f in sorted(remaining):
        print(f"  {f.name}")


if __name__ == '__main__':
    main()
