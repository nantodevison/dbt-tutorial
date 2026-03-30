"""Génération de la correspondance de renommage des macros dbt.

Règles :
- Toutes les macros commencent par 'mcr_'
- Format : mcr_N_nom_abrégé  (N = numéro DAG du modèle appelant, 'xx' si plusieurs)
- Abréviations françaises distinctes des modèles :
    'verifier'/'verif' → 'vrf' (modèles : 'chk')
    'update' → 'maj' (modèles : 'upd')
- Reprend les abréviations communes des modèles pour le reste

Produit :
- correspondance_renommage_macros.csv
- documentation_abreviations_macros.csv
"""

import csv
import re
from pathlib import Path

PROJECT_DIR = Path(__file__).parent
MACROS_DIR = PROJECT_DIR / 'macros'
MODELS_DIR = PROJECT_DIR / 'models'

# ---- Abréviations (triées par longueur décroissante) ----
ABBREVIATIONS = sorted([
    # Verbes (spécifiques macros, français vs anglais pour les modèles)
    ('verifier', 'vrf'),
    ('verifer', 'vrf'),     # typo existante dans mcr_verifer_id_comptag
    ('verif', 'vrf'),       # forme courte dans cte_verif_*
    ('update', 'maj'),
    ('comparer', 'cmp'),
    ('ajouter', 'aj'),
    # Noms / concepts (communs avec les modèles)
    ('standardisation', 'std'),
    ('stdardisation', 'std'),
    ('gestionnaires', 'gest'),
    ('gestionnaire', 'gest'),
    ('linearisation', 'linear'),
    ('statistiques', 'stats'),
    ('aberrantes', 'aberr'),
    ('millessime', 'mill'),
    ('millesime', 'mill'),
    ('limitrophe', 'limitr'),
    ('estimation', 'estim'),
    ('historique', 'histo'),
    ('hors_agglo', 'h_agglo'),
    ('horsagglo', 'h_agglo'),
    ('coherence', 'coher'),
    ('bretelles', 'bret'),
    ('linearise', 'linear'),
    ('lineaire', 'linear'),
    ('comptage', 'cptg'),
    ('abertes', 'aberr'),
    ('nouveau', 'nouv'),
    ('valeurs', 'val'),
    ('comptag', 'cptg'),
    ('section', 'sect'),
    ('estimee', 'estim'),
    ('trafic', 'traf'),
    ('coment', 'cmt'),
    ('bdtopo', 'bdt'),
    ('troncon', 'tronc'),
    ('devient', 'dev'),
    ('values', 'val'),
    ('evol', 'evo'),
], key=lambda x: len(x[0]), reverse=True)


def extract_macro_name(filepath: Path) -> str | None:
    """Extrait le nom interne de la macro depuis {% macro NOM(...) %}."""
    content = filepath.read_text(encoding='utf-8')
    m = re.search(r'\{%[-\s]*macro\s+(\w+)', content)
    return m.group(1) if m else None


def find_model_callers(macro_internal_name: str, models_dir: Path) -> list[str]:
    """Trouve les fichiers modèle .sql appelant cette macro (correspondance exacte)."""
    pattern = re.compile(r'(?<![a-zA-Z0-9_])' + re.escape(macro_internal_name) + r'(?![a-zA-Z0-9_])')
    callers = []
    for fpath in models_dir.rglob('*.sql'):
        content = fpath.read_text(encoding='utf-8')
        if pattern.search(content):
            callers.append(fpath.stem)
    return sorted(callers)


def find_macro_callers(macro_internal_name: str, macros_dir: Path, exclude_file: Path) -> list[str]:
    """Trouve les autres macros appelant cette macro."""
    pattern = re.compile(r'(?<![a-zA-Z0-9_])' + re.escape(macro_internal_name) + r'(?![a-zA-Z0-9_])')
    callers = []
    for fpath in macros_dir.glob('*.sql'):
        if fpath == exclude_file:
            continue
        content = fpath.read_text(encoding='utf-8')
        if pattern.search(content):
            callers.append(fpath.stem)
    return sorted(callers)


def extract_dag_number(model_name: str) -> str | None:
    """Extrait le numéro DAG d'un nom de modèle renommé.
    mdl12b_... → '12b'
    cte1_mdl12b_... → '12b'  (numéro du modèle parent)
    """
    m = re.match(r'(?:cte\d+_)?mdl(\d+[a-z]?)_', model_name)
    return m.group(1) if m else None


def extract_cte_number(model_name: str) -> str | None:
    """Extrait le numéro CTE d'un nom de modèle renommé.
    cte1_mdl6_... → '1'
    cte3_mdl16e_... → '3'
    mdl12b_... → None  (pas un CTE)
    """
    m = re.match(r'cte(\d+)_mdl', model_name)
    return m.group(1) if m else None


def abbreviate(name: str) -> str:
    """Applique les abréviations au nom."""
    for long_form, short_form in ABBREVIATIONS:
        name = name.replace(long_form, short_form)
    return name


def main():
    # ---- 1. Collecter les macros ----
    macros = {}
    for macro_file in sorted(MACROS_DIR.glob('*.sql')):
        basename = macro_file.stem
        internal_name = extract_macro_name(macro_file)
        if internal_name:
            macros[basename] = {
                'internal_name': internal_name,
                'path': macro_file,
            }

    print(f"Trouve {len(macros)} macros\n")

    # ---- 2. Trouver les appelants ----
    for basename, info in macros.items():
        iname = info['internal_name']
        info['model_callers'] = find_model_callers(iname, MODELS_DIR)
        info['macro_callers'] = find_macro_callers(iname, MACROS_DIR, info['path'])

    # ---- 3. Déterminer le numéro DAG ----
    for basename, info in macros.items():
        # Extraire les numéros uniques des modèles appelants
        numbers = set()
        for caller in info['model_callers']:
            num = extract_dag_number(caller)
            if num:
                numbers.add(num)

        if len(numbers) == 1:
            info['dag_number'] = numbers.pop()
        else:
            info['dag_number'] = 'xx'

    # ---- 4. Construire les nouveaux noms ----
    for basename, info in macros.items():
        # Partir du nom de fichier (référence stable)
        name = basename
        is_cte = name.startswith('cte_')

        # Retirer le préfixe existant
        if name.startswith('mcr_'):
            name = name[4:]
        elif name.startswith('cte_'):
            name = name[4:]

        # Appliquer les abréviations
        name = abbreviate(name)

        # Déterminer le numéro CTE si macro CTE
        cte_prefix = ''
        if is_cte:
            # Chercher le numéro CTE dans le modèle appelant
            for caller in info['model_callers']:
                cte_num = extract_cte_number(caller)
                if cte_num:
                    cte_prefix = f'cte{cte_num}_'
                    break
            if not cte_prefix:
                # Fallback : pas de numéro trouvé, garder cte_ sans numéro
                cte_prefix = 'cte_'

        # Construire le nouveau nom : [cteN_]mcr_DAG_...
        new_name = f"{cte_prefix}mcr_{info['dag_number']}_{name}"

        info['new_name'] = new_name

    # ---- 5. Vérifier les doublons ----
    seen = {}
    for basename, info in macros.items():
        nn = info['new_name']
        if nn in seen:
            print(f"  DOUBLON : {nn} <- {basename} et {seen[nn]}")
        seen[nn] = basename

    # ---- 6. Écrire le CSV de correspondance ----
    csv_path = PROJECT_DIR / 'correspondance_renommage_macros.csv'
    with open(csv_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f, delimiter=';')
        writer.writerow([
            'ancien_nom_fichier', 'ancien_nom_interne', 'nouveau_nom',
            'niveau_appelant', 'modeles_appelants', 'macros_appelantes',
            'chemin_fichier',
        ])
        for basename in sorted(macros.keys()):
            info = macros[basename]
            writer.writerow([
                basename,
                info['internal_name'],
                info['new_name'],
                info['dag_number'],
                ', '.join(info['model_callers']),
                ', '.join(info['macro_callers']),
                str(info['path'].relative_to(PROJECT_DIR)),
            ])

    print(f"Correspondance ecrite : {csv_path}")

    # ---- 7. Écrire le CSV de documentation ----
    doc_csv_path = PROJECT_DIR / 'documentation_abreviations_macros.csv'
    with open(doc_csv_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f, delimiter=';')
        writer.writerow(['abreviation', 'mot_complet', 'categorie', 'commentaire'])

        doc_entries = [
            # Préfixes structurels
            ('mcr', 'macro', 'prefixe structurel',
             "prefixe obligatoire pour toutes les macros dbt (remplace cte_, verifier_, update_, etc.)"),
            ('N', 'numero DAG', 'prefixe structurel',
             "numero du modele appelant unique (ex: 12b, 6)"),
            ('xx', 'multiple', 'prefixe structurel',
             "indique que la macro est appelee par plusieurs modeles de niveaux DAG differents"),
            # Verbes spécifiques macros
            ('vrf', 'verifier', 'operation',
             "macro de verification (remplace verifier/verif, different de chk pour les modeles)"),
            ('maj', 'mise a jour', 'operation',
             "macro de mise a jour (remplace update, different de upd pour les modeles)"),
            ('cmp', 'comparer', 'operation',
             "macro de comparaison (remplace comparer)"),
            ('aj', 'ajouter', 'operation',
             "macro d'ajout (remplace ajouter)"),
            # Abréviations communes (réutilisées des modèles)
            ('lin', 'linearisation', 'domaine',
             "contexte linearisation (suffixe conserve)"),
            ('linear', 'linearisation / linearise / lineaire', 'metier',
             "processus de linearisation (remplace linearisation, linearise, lineaire)"),
            ('bdt', 'BD TOPO', 'source de donnees',
             "base de donnees topographique IGN (remplace bdtopo)"),
            ('cptg', 'comptage', 'metier',
             "point de comptage (remplace comptag, comptage)"),
            ('cmt', 'commentaire', 'operation',
             "commentaire sur un indicateur (remplace coment)"),
            ('stats', 'statistiques', 'operation',
             "calculs statistiques (remplace statistiques)"),
            ('gest', 'gestionnaire(s)', 'metier',
             "gestionnaires de voirie (remplace gestionnaires, gestionnaire)"),
            ('estim', 'estimation / estimee', 'metier',
             "valeur estimee (remplace estimation, estimee)"),
            ('histo', 'historique', 'metier',
             "donnees historiques (remplace historique)"),
            ('mill', 'millesime', 'metier',
             "annee de reference (remplace millessime, millesime)"),
            ('limitr', 'limitrophe', 'metier',
             "departement limitrophe (remplace limitrophe)"),
            ('coher', 'coherence', 'operation',
             "verification de coherence (remplace coherence)"),
            ('traf', 'trafic', 'metier',
             "indicateur de trafic (remplace trafic)"),
            ('aberr', 'aberrantes', 'metier',
             "valeurs aberrantes (remplace aberrantes, abertes)"),
            ('nouv', 'nouveau', 'metier',
             "nouveau point de comptage (remplace nouveau)"),
            ('bret', 'bretelles', 'metier',
             "bretelles acces RRN (remplace bretelles)"),
            ('sect', 'section', 'metier',
             "section homogene (remplace section)"),
            ('h_agglo', 'hors agglomeration', 'metier',
             "zone hors agglomeration (remplace horsagglo, hors_agglo)"),
            ('std', 'standardisation', 'operation',
             "standardisation des comptages (remplace standardisation/stdardisation)"),
            ('evo', 'evolution', 'metier',
             "evolution (remplace evol)"),
            ('dev', 'devenu / devient', 'metier',
             "devenu (remplace devient)"),
            ('val', 'valeur / values / valeurs', 'metier',
             "valeur d'un indicateur (remplace values, valeurs)"),
            ('tronc', 'troncon', 'metier',
             "troncon de route (remplace troncon)"),
        ]

        for entry in doc_entries:
            writer.writerow(entry)

    print(f"Documentation ecrite : {doc_csv_path}")

    # ---- 8. Résumé ----
    n_single = sum(1 for info in macros.values() if info['dag_number'] != 'xx')
    n_multi = sum(1 for info in macros.values() if info['dag_number'] == 'xx')
    print(f"\nResume :")
    print(f"  - {len(macros)} macros")
    print(f"  - {n_single} avec numero unique")
    print(f"  - {n_multi} multi-modeles (xx)")

    # Détails multi-modèles
    if n_multi > 0:
        print(f"\nMacros multi-modeles :")
        for basename in sorted(macros.keys()):
            info = macros[basename]
            if info['dag_number'] == 'xx':
                numbers = set()
                for c in info['model_callers']:
                    num = extract_dag_number(c)
                    if num:
                        numbers.add(num)
                callers_str = ', '.join(info['model_callers'])
                print(f"  {basename}")
                print(f"    -> niveaux {sorted(numbers)} <- [{callers_str}]")

    # Macros dont le nom interne diffère du fichier
    mismatches = [(b, i) for b, i in ((b, macros[b]['internal_name']) for b in macros) if b != i]
    if mismatches:
        print(f"\nNoms internes differents du fichier ({len(mismatches)}) :")
        for basename, internal in mismatches:
            print(f"  fichier: {basename}")
            print(f"  interne: {internal}")
            print(f"  nouveau: {macros[basename]['new_name']}")
            print()

    # Aperçu des 10 premiers renommages
    print(f"\nApercu (10 premiers) :")
    for i, basename in enumerate(sorted(macros.keys())):
        if i >= 10:
            break
        info = macros[basename]
        print(f"  {basename}")
        print(f"    -> {info['new_name']}  (niveau {info['dag_number']})")


if __name__ == '__main__':
    main()
