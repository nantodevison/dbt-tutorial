"""Script d'application du renommage des macros dbt.

Lit correspondance_renommage_macros.csv et applique :
1. Mise à jour des contenus ({% macro %}, appels, name:, liens doc) dans .sql et .yml
2. Renommage physique des fichiers .sql dans macros/

Pour chaque macro, DEUX anciens noms peuvent exister :
- ancien_nom_fichier (nom du fichier .sql sans extension)
- ancien_nom_interne (nom dans {% macro ... %}) — parfois différent du fichier

Les deux doivent être remplacés par le nouveau nom unique.

Priorité absolue : ne pas modifier le comportement ni le DAG.
"""

import csv
import re
from pathlib import Path

PROJECT_DIR = Path(__file__).parent
CSV_PATH = PROJECT_DIR / 'correspondance_renommage_macros.csv'

# Fichiers à exclure de la vérification résiduelle
EXCLUDED_FILES = {
    'correspondance_renommage_macros.csv',
    'correspondance_renommage.csv',
    'appliquer_renommage_macros.py',
    'appliquer_renommage.py',
    'generer_correspondance_renommage.py',
    'generer_correspondance_renommage_macros.py',
    'documentation_abreviations.csv',
    'documentation_abreviations_macros.csv',
}


def load_mapping() -> list[dict]:
    with open(CSV_PATH, encoding='utf-8') as f:
        return list(csv.DictReader(f, delimiter=';'))


def main() -> None:
    rows = load_mapping()

    # ---- 1. Construire les patterns de remplacement ----
    # Collecter toutes les paires (ancien, nouveau) — un même nouveau peut
    # avoir 2 anciens si nom_fichier ≠ nom_interne
    replacements: dict[str, str] = {}  # ancien → nouveau
    file_renames: list[dict] = []      # pour le renommage physique

    for row in rows:
        old_file = row['ancien_nom_fichier']
        old_internal = row['ancien_nom_interne']
        new_name = row['nouveau_nom']

        # Toujours ajouter le nom interne (c'est celui utilisé dans le code)
        replacements[old_internal] = new_name

        # Si le nom de fichier diffère, l'ajouter aussi
        if old_file != old_internal:
            replacements[old_file] = new_name

        file_renames.append(row)

    print(f"Chargé {len(rows)} macros, {len(replacements)} patterns de remplacement")

    # Trier par longueur décroissante pour éviter les remplacements partiels
    sorted_old_names = sorted(replacements.keys(), key=len, reverse=True)

    # Compiler les regex avec gardes de limites de mot
    compiled_replacements: list[tuple[re.Pattern, str, str]] = []
    for old_name in sorted_old_names:
        new_name = replacements[old_name]
        pattern = re.compile(
            r'(?<![a-zA-Z0-9_])' + re.escape(old_name) + r'(?![a-zA-Z0-9_])'
        )
        compiled_replacements.append((pattern, new_name, old_name))

    print(f"  dont {sum(1 for r in rows if r['ancien_nom_fichier'] != r['ancien_nom_interne'])} macro(s) avec nom interne ≠ fichier")

    # ---- 2. Appliquer les remplacements dans les fichiers ----
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

    # Dédupliquer
    files_to_update = list(set(files_to_update))

    print(f"\n2. Scan de {len(files_to_update)} fichiers pour mise à jour des références...")

    total_changes = 0
    files_changed = 0

    for fpath in sorted(files_to_update):
        try:
            content = fpath.read_text(encoding='utf-8')
        except (UnicodeDecodeError, PermissionError):
            continue

        original = content
        file_changes = 0

        for pattern, new_name, old_name in compiled_replacements:
            if pattern.search(content):
                content, n = pattern.subn(new_name, content)
                file_changes += n

        if content != original:
            fpath.write_text(content, encoding='utf-8')
            files_changed += 1
            total_changes += file_changes
            print(f"   OK {fpath.relative_to(PROJECT_DIR)} ({file_changes} remplacement(s))")

    print(f"\n   → {files_changed} fichier(s) modifié(s), {total_changes} remplacement(s) au total")

    # ---- 3. Renommer les fichiers physiques ----
    print(f"\n3. Renommage des fichiers...")

    renamed_count = 0
    rename_errors: list[str] = []

    for row in file_renames:
        old_file_name = row['ancien_nom_fichier']
        new_name = row['nouveau_nom']
        rel_path = row['chemin_fichier']
        old_path = PROJECT_DIR / rel_path

        if not old_path.exists():
            rename_errors.append(f"Fichier introuvable : {rel_path}")
            continue

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

    # ---- 4. Vérifications post-renommage ----
    print(f"\n4. Vérifications post-renommage...")

    # 4a. Vérifier que tous les nouveaux fichiers existent
    missing_files = []
    for row in file_renames:
        rel_path = row['chemin_fichier']
        old_path = PROJECT_DIR / rel_path
        new_name = row['nouveau_nom']
        expected_path = old_path.parent / (new_name + '.sql')
        if not expected_path.exists():
            missing_files.append(str(expected_path.relative_to(PROJECT_DIR)))

    if not missing_files:
        print(f"   OK  Tous les {len(file_renames)} fichiers renommés existent")
    else:
        print(f"   ERR {len(missing_files)} fichier(s) manquant(s) :")
        for mf in missing_files[:10]:
            print(f"     {mf}")

    # 4b. Recherche de noms anciens résiduels
    print(f"\n   Recherche de noms anciens résiduels...")
    residual_refs: list[tuple[str, str, str]] = []

    for d in scan_dirs:
        dir_path = PROJECT_DIR / d
        if not dir_path.exists():
            continue
        for fpath in dir_path.rglob('*'):
            if not fpath.is_file() or fpath.suffix not in ('.sql', '.yml'):
                continue
            if fpath.name in EXCLUDED_FILES:
                continue
            try:
                content = fpath.read_text(encoding='utf-8')
            except (UnicodeDecodeError, PermissionError):
                continue
            for old_name in sorted_old_names:
                new_name = replacements[old_name]
                # Vérifier avec limites de mot
                pat = re.compile(
                    r'(?<![a-zA-Z0-9_])' + re.escape(old_name) + r'(?![a-zA-Z0-9_])'
                )
                matches = pat.findall(content)
                if matches:
                    lines = [
                        i + 1
                        for i, line in enumerate(content.split('\n'))
                        if pat.search(line)
                    ]
                    residual_refs.append((
                        str(fpath.relative_to(PROJECT_DIR)),
                        old_name,
                        f"lignes {lines[:5]}"
                    ))

    if not residual_refs:
        print(f"   OK  Aucun ancien nom résiduel trouvé")
    else:
        print(f"   WARN {len(residual_refs)} référence(s) résiduelle(s) :")
        for filepath, old_name, detail in residual_refs[:20]:
            print(f"     {filepath} : '{old_name}' ({detail})")

    print(f"\nTerminé.")


if __name__ == '__main__':
    main()
