"""Script d'application du renommage des modèles et seeds dbt.

Lit correspondance_renommage.csv et applique :
1. Mise à jour des contenus (ref(), name:, etc.) dans .sql et .yml
2. Mise à jour de dbt_project.yml (noms de seeds dans configs)
3. Renommage physique des fichiers .sql et .csv

Priorité absolue : ne pas modifier le comportement ni le DAG.
"""

import csv
import os
import re
from pathlib import Path

PROJECT_DIR = Path(__file__).parent
CSV_PATH = PROJECT_DIR / 'correspondance_renommage.csv'
DEPT = '19'

# ---- 1. Lecture du CSV ----
def load_mapping() -> list[dict]:
    with open(CSV_PATH, encoding='utf-8') as f:
        return list(csv.DictReader(f, delimiter=';'))

def main() -> None:
    rows = load_mapping()

    # Mapping ancien_nom → nom_abrev
    mapping: dict[str, str] = {}
    type_map: dict[str, str] = {}  # ancien_nom → type (model/seed)
    path_map: dict[str, str] = {}  # ancien_nom → chemin_fichier

    for row in rows:
        old = row['ancien_nom']
        new = row['nom_abrev']
        mapping[old] = new
        type_map[old] = row['type']
        path_map[old] = row['chemin_fichier']

    print(f"Chargé {len(mapping)} correspondances ({sum(1 for t in type_map.values() if t == 'model')} modèles, {sum(1 for t in type_map.values() if t == 'seed')} seeds)")

    # ---- 2. Construire les patterns de remplacement ----
    # Tri par longueur décroissante pour éviter les remplacements partiels
    # (ex: 'lin_verif_cpt_mm_section_homo_19__format_agreg' avant 'lin_verif_cpt_mm_section_homo_19')
    sorted_old_names = sorted(mapping.keys(), key=len, reverse=True)

    # 2a. Remplacements de noms complets (avec gardes pour éviter double-préfixage)
    full_replacements: list[tuple[re.Pattern, str]] = [
        (re.compile(r'(?<![a-zA-Z0-9_])' + re.escape(old) + r'(?![a-zA-Z0-9_])'), mapping[old])
        for old in sorted_old_names
    ]

    # 2b. Remplacements de tiges pour ref() dynamiques de type :
    #   ref('old_stem_' ~ dept)   ou   ref('old_stem_' ~ var('dept'))
    # On construit des regex ciblées pour ne remplacer QUE dans ce contexte,
    # évitant ainsi le double-préfixage des noms déjà remplacés en 2a.
    #
    # Deux catégories de modèles :
    #  - Noms finissant par '_' + DEPT (ex: lin_verif_pt_non_linearise_19)
    #    → pattern: 'old_stem_' ~ dept
    #  - Noms avec '_' + DEPT + '__suffix' (ex: lin_cte_..._19__choix_cpt_tronc)
    #    → pattern: 'old_prefix_' ~ dept ~ '__suffix'

    # Type A : noms finissant par _DEPT (stem = nom sans DEPT)
    stem_end_replacements: list[tuple[re.Pattern, str]] = []
    for old in sorted_old_names:
        if type_map[old] != 'model':
            continue
        if old.endswith('_' + DEPT) and '__' not in old[old.rfind('_' + DEPT):]:
            old_stem = old[:-len(DEPT)]  # 'lin_verif_pt_non_linearise_'
            new_stem = mapping[old][:-len(DEPT)]  # 'mdl5_lin_chk_pt_non_linear_'
            if old_stem != new_stem:
                # Match: 'old_stem' suivi de ' ~ dept ou '~ dept ou '~dept etc.
                pat = re.compile(r'(?<![a-zA-Z0-9_])' + re.escape(old_stem) + r"(?='?\s*~)")
                stem_end_replacements.append((pat, new_stem))

    # Type B : noms avec _DEPT_ au milieu (CTE models et format_agreg)
    stem_mid_replacements: list[tuple[re.Pattern, str]] = []
    for old in sorted_old_names:
        if type_map[old] != 'model':
            continue
        # Chercher _DEPT suivi de __ dans le nom
        dept_marker = '_' + DEPT + '__'
        idx = old.find(dept_marker)
        if idx < 0 or old.endswith('_' + DEPT):
            continue
        old_prefix = old[:idx + 1]  # 'lin_cte_update_auto_pt_non_linearise_'
        old_suffix = old[idx + 1 + len(DEPT):]  # '__choix_cpt_tronc'
        new_name = mapping[old]
        new_dept_marker_idx = new_name.find('_' + DEPT + '__')
        if new_dept_marker_idx < 0:
            # Essai : le nouveau nom finit aussi par __suffix mais DEPT peut être ailleurs
            new_dept_marker_idx = new_name.find('_' + DEPT + '_')
            if new_dept_marker_idx < 0:
                continue
        new_prefix = new_name[:new_dept_marker_idx + 1]
        new_suffix = new_name[new_dept_marker_idx + 1 + len(DEPT):]
        # Pattern: 'old_prefix' ~ dept ~ 'old_suffix'
        # avec variations d'espacement
        pat = re.compile(
            re.escape(old_prefix) + r"'\s*~\s*((?:var\('dept'\))|dept)\s*~\s*'" + re.escape(old_suffix)
        )
        repl = new_prefix + r"' ~ \1 ~ '" + new_suffix
        stem_mid_replacements.append((pat, repl))

    # Type C : seeds dynamiques
    # Pattern: ref('dept' ~ dept ~ '_old_suffix') → ref('new_prefix_dept' ~ dept ~ '_new_suffix')
    seed_stem_replacements: list[tuple[re.Pattern, str]] = []
    for old in sorted_old_names:
        if type_map[old] == 'seed' and old.startswith('dept' + DEPT + '_'):
            old_suffix = old[len('dept' + DEPT):]  # '_update_coment_tmj_f_sens'
            new_name = mapping[old]
            idx = new_name.find('dept' + DEPT)
            if idx < 0:
                continue
            new_prefix = new_name[:idx]  # 'sed17a_'
            new_suffix = new_name[idx + len('dept' + DEPT):]  # '_upd_cmt_tmj_f_sens'
            pat = re.compile(
                r"'dept'\s*~\s*dept\s*~\s*'" + re.escape(old_suffix) + r"'"
            )
            repl = f"'{new_prefix}dept' ~ dept ~ '{new_suffix}'"
            seed_stem_replacements.append((pat, repl))

    # Trier les listes par longueur de pattern décroissante
    stem_end_replacements.sort(key=lambda x: len(x[1]), reverse=True)
    stem_mid_replacements.sort(key=lambda x: len(x[1]), reverse=True)

    print(f"\nPatterns de remplacement :")
    print(f"  - {len(full_replacements)} noms complets")
    print(f"  - {len(stem_end_replacements)} tiges fin-dept (ref('stem_' ~ dept))")
    print(f"  - {len(stem_mid_replacements)} tiges mid-dept (ref('prefix_' ~ dept ~ '__suffix'))")
    print(f"  - {len(seed_stem_replacements)} tiges seeds (ref('dept' ~ dept ~ '_suffix'))")

    # ---- 3. Appliquer les remplacements dans les fichiers ----
    # Fichiers à scanner : tous les .sql et .yml sous models/, macros/, seeds/
    # + dbt_project.yml
    scan_dirs = ['models', 'macros', 'seeds']
    files_to_update: list[Path] = []
    for d in scan_dirs:
        dir_path = PROJECT_DIR / d
        if dir_path.exists():
            for ext in ('*.sql', '*.yml'):
                files_to_update.extend(dir_path.rglob(ext))

    # Ajouter dbt_project.yml
    dbt_project_path = PROJECT_DIR / 'dbt_project.yml'
    if dbt_project_path.exists():
        files_to_update.append(dbt_project_path)

    # Ajouter les yml dans macros (schema_macro.yml etc.)
    macro_ymls = list((PROJECT_DIR / 'macros').rglob('*.yml')) if (PROJECT_DIR / 'macros').exists() else []
    for yml in macro_ymls:
        if yml not in files_to_update:
            files_to_update.append(yml)

    print(f"\n3. Scan de {len(files_to_update)} fichiers pour mise à jour des références...")

    total_changes = 0
    files_changed = 0

    for fpath in files_to_update:
        try:
            content = fpath.read_text(encoding='utf-8')
        except (UnicodeDecodeError, PermissionError):
            continue

        original = content
        file_changes = 0

        # 3a. Remplacements de noms complets (les plus longs d'abord)
        for old_pat, new_name in full_replacements:
            m = old_pat.search(content)
            if m:
                content, n = old_pat.subn(new_name, content)
                file_changes += n

        # 3b. Remplacements de tiges pour ref() dynamiques (fin-dept)
        for pat, new_stem in stem_end_replacements:
            m = pat.search(content)
            if m:
                content, n = pat.subn(new_stem, content)
                file_changes += n

        # 3c. Remplacements de tiges pour ref() dynamiques (mid-dept)
        for pat, repl in stem_mid_replacements:
            m = pat.search(content)
            if m:
                content, n = pat.subn(repl, content)
                file_changes += n

        # 3d. Remplacements de tiges de seeds dynamiques
        for pat, repl in seed_stem_replacements:
            m = pat.search(content)
            if m:
                content, n = pat.subn(repl, content)
                file_changes += n

        if content != original:
            fpath.write_text(content, encoding='utf-8')
            files_changed += 1
            total_changes += file_changes
            print(f"   OK {fpath.relative_to(PROJECT_DIR)} ({file_changes} remplacement(s))")

    print(f"\n   → {files_changed} fichier(s) modifié(s), {total_changes} remplacement(s) au total")

    # ---- 4. Renommer les fichiers ----
    print(f"\n4. Renommage des fichiers...")

    renamed_count = 0
    rename_errors: list[str] = []

    for old_name, new_name in mapping.items():
        rel_path = path_map[old_name]
        old_path = PROJECT_DIR / rel_path

        if not old_path.exists():
            rename_errors.append(f"Fichier introuvable : {rel_path}")
            continue

        # Le nouveau nom de fichier : même répertoire, nouveau nom + même extension
        new_filename = new_name + old_path.suffix
        new_path = old_path.parent / new_filename

        if new_path.exists() and new_path != old_path:
            rename_errors.append(f"Conflit : {new_path.name} existe déjà")
            continue

        if old_path != new_path:
            old_path.rename(new_path)
            renamed_count += 1
            print(f"   OK {old_path.name} -> {new_path.name}")

    print(f"\n   → {renamed_count} fichier(s) renommé(s)")
    if rename_errors:
        print(f"   WARN {len(rename_errors)} erreur(s) :")
        for err in rename_errors:
            print(f"     {err}")

    # ---- 5. Vérifications post-renommage ----
    print(f"\n5. Vérifications post-renommage...")

    # 5a. Vérifier que tous les nouveaux fichiers existent
    missing_files = []
    for old_name, new_name in mapping.items():
        rel_path = path_map[old_name]
        old_path = PROJECT_DIR / rel_path
        ext = Path(rel_path).suffix
        expected_path = old_path.parent / (new_name + ext)
        if not expected_path.exists():
            missing_files.append(str(expected_path.relative_to(PROJECT_DIR)))
    if not missing_files:
        print(f"   OK  Tous les {len(mapping)} fichiers renommés existent")
    else:
        print(f"   ERR {len(missing_files)} fichier(s) manquant(s) : {missing_files[:5]}")

    # 5b. Vérifier qu'aucun ancien nom n'apparaît encore dans les sources
    # (sauf dans les commentaires, le CSV de correspondance, et ce script)
    print(f"\n   Recherche de noms anciens résiduels...")
    residual_refs: list[tuple[str, str, str]] = []
    excluded_files = {
        'correspondance_renommage.csv',
        'appliquer_renommage.py',
        'generer_correspondance_renommage.py',
        'documentation_abreviations.csv',
    }
    for d in scan_dirs:
        dir_path = PROJECT_DIR / d
        if not dir_path.exists():
            continue
        for fpath in dir_path.rglob('*'):
            if fpath.is_file() and fpath.suffix in ('.sql', '.yml') and fpath.name not in excluded_files:
                try:
                    content = fpath.read_text(encoding='utf-8')
                except (UnicodeDecodeError, PermissionError):
                    continue
                for old_name in sorted_old_names:
                    if old_name in content:
                        # Vérifier que c'est une vraie référence (pas un sous-mot du nouveau nom)
                        new_name = mapping[old_name]
                        if new_name not in content or old_name not in new_name:
                            lines = [i+1 for i, line in enumerate(content.split('\n')) if old_name in line]
                            residual_refs.append((
                                str(fpath.relative_to(PROJECT_DIR)),
                                old_name,
                                f"lignes {lines[:3]}"
                            ))

    if not residual_refs:
        print(f"   OK  Aucun ancien nom résiduel trouvé")
    else:
        print(f"   WARN {len(residual_refs)} reference(s) residuelle(s) :")
        for fpath, old_name, lines in residual_refs[:20]:
            print(f"     {fpath} : '{old_name}' ({lines})")

    print("\nTerminé !")


if __name__ == '__main__':
    main()
