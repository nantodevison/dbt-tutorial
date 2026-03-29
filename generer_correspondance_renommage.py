"""
generer_correspondance_renommage.py

Génère un fichier CSV de correspondance entre les anciens et nouveaux noms
de modèles/seeds dbt pour le département 19, avec un préfixe numéroté
reflétant l'ordre d'exécution dans le DAG.

Format des nouveaux noms :
  - Modèles :  mdl<N>[<lettre>]_<nom_existant>
  - CTE :      cte<K>_mdl<N>[<lettre>]_<nom_existant>
  - Seeds :    sed<N>[<lettre>]_<nom_existant>

Usage : python generer_correspondance_renommage.py
Output : correspondance_renommage.csv
"""
from __future__ import annotations

import csv
import os
import re
from collections import defaultdict, deque
from pathlib import Path

# --- Configuration ---
DEPT = '19'
PROJECT_DIR = Path(__file__).parent
MODELS_DEPT_DIR = PROJECT_DIR / 'models' / f'dept{DEPT}'
MACROS_DIR = PROJECT_DIR / 'macros'
SEEDS_DIR = PROJECT_DIR / 'seeds'
OUTPUT_CSV = PROJECT_DIR / 'correspondance_renommage.csv'

JINJA_BUILTINS = frozenset({
    'ref', 'source', 'config', 'var', 'this', 'log', 'return',
    'adapter', 'run_query', 'set', 'is_incremental', 'if', 'elif',
    'else', 'for', 'endfor', 'endif', 'macro', 'endmacro', 'call',
    'block', 'endblock', 'do', 'print', 'not', 'and', 'or',
    'true', 'false', 'none', 'loop', 'range', 'dict', 'namespace',
})


# ============================================================
# Parsing
# ============================================================

def resolve_jinja_ref(raw: str) -> str | None:
    """Résout une expression ref() Jinja en nom concret de modèle/seed.

    Gère :
      ref('nom_statique')
      ref('prefix_' ~ dept)
      ref('prefix_' ~ var('dept'))
      ref('dept' ~ dept ~ '_suffix')
    """
    s = raw.strip()

    # Cas simple : ref('name') ou ref("name")
    m = re.match(r"""^['"]([^'"]+)['"]$""", s)
    if m:
        return m.group(1)

    if '~' not in s:
        return None

    # Remplacer var('dept') / var("dept") par la valeur littérale
    s = re.sub(r"""var\(\s*['"]dept['"]\s*\)""", f"'{DEPT}'", s)

    parts = s.split('~')
    result = ''
    for part in parts:
        part = part.strip()
        quoted = re.match(r"""^['"](.*)['"]$""", part)
        if quoted:
            result += quoted.group(1)
        elif part == 'dept':
            result += DEPT
        elif part == DEPT:
            result += DEPT
        else:
            # Variable inconnue (annee_n_1, etc.) → on ne peut pas résoudre
            return None

    return result or None


def extract_all_refs(content: str) -> set[str]:
    """Extrait toutes les dépendances ref() d'un contenu SQL/Jinja."""
    refs: set[str] = set()

    # -- depends_on: {{ ref('name') }}
    for m in re.finditer(
        r"""--\s*depends_on:\s*\{\{\s*ref\(\s*['"]([^'"]+)['"]\s*\)\s*\}\}""",
        content,
    ):
        refs.add(m.group(1))

    # Tous les ref(...) — gère un niveau de parenthèses imbriquées (ex: var('dept'))
    for m in re.finditer(r"""ref\(\s*((?:[^()]*|\([^()]*\))*)\s*\)""", content):
        resolved = resolve_jinja_ref(m.group(1))
        if resolved:
            refs.add(resolved)

    return refs


def extract_macro_calls(content: str) -> list[str]:
    """Extrait les noms de macros appelées dans un contenu Jinja."""
    macros = set()
    for m in re.finditer(r"""\{\{[\s-]*([a-zA-Z_]\w*)\s*\(""", content):
        name = m.group(1)
        if name.lower() not in JINJA_BUILTINS:
            macros.add(name)
    # Aussi capturer les appels dans {% set x = macro(...) %}
    for m in re.finditer(r"""\{%[-\s]*set\s+\w+\s*=\s*([a-zA-Z_]\w*)\s*\(""", content):
        name = m.group(1)
        if name.lower() not in JINJA_BUILTINS:
            macros.add(name)
    return list(macros)


def parse_macro_file(filepath: Path) -> dict:
    """Parse un fichier macro et retourne {name, refs, inner_macros}."""
    content = filepath.read_text(encoding='utf-8', errors='replace')

    # Nom de la macro définie
    m = re.search(r"""\{%[-\s]*macro\s+(\w+)\s*\(""", content)
    name = m.group(1) if m else filepath.stem

    refs = extract_all_refs(content)

    # Appels internes à d'autres macros
    exclude = JINJA_BUILTINS | {name}  # exclure auto-référence
    inner = set()
    for mm in re.finditer(r"""\{\{[\s-]*(\w+)\s*\(""", content):
        n = mm.group(1)
        if n not in exclude:
            inner.add(n)
    for mm in re.finditer(r"""\{%[-\s]*set\s+\w+\s*=\s*(\w+)\s*\(""", content):
        n = mm.group(1)
        if n not in exclude:
            inner.add(n)
    # Appels de type macro_name(...) sans {{ (dans le corps de la macro)
    for mm in re.finditer(r"""(?<!\w)([a-zA-Z_]\w*)\s*\(\s*(?:dept|annee|seuil|var)""", content):
        n = mm.group(1)
        if n not in exclude and not n.startswith(('ref', 'source', 'var', 'config')):
            inner.add(n)

    return {'name': name, 'refs': refs, 'inner_macros': list(inner)}


def resolve_macro_refs(
    macro_name: str,
    macros: dict[str, dict],
    visited: set[str] | None = None,
) -> set[str]:
    """Résout récursivement les refs d'une macro et de ses appels internes."""
    if visited is None:
        visited = set()
    if macro_name in visited or macro_name not in macros:
        return set()
    visited.add(macro_name)

    macro = macros[macro_name]
    all_refs = set(macro['refs'])
    for inner in macro['inner_macros']:
        all_refs |= resolve_macro_refs(inner, macros, visited)
    return all_refs


# ============================================================
# CTE / modèle identification
# ============================================================

def is_cte_model(name: str, filepath: Path) -> bool:
    """Un modèle est CTE s'il contient '_cte_' ou vit dans un sous-dossier cte/."""
    if '_cte_' in name:
        return True
    return 'cte' in filepath.parent.parts


# ============================================================
# Numérotation
# ============================================================

def to_letter_suffix(index: int) -> str:
    """Convertit un index 0-based en suffixe alphabétique : 0→a, …, 25→z, 26→aa, …"""
    if index < 26:
        return chr(ord('a') + index)
    # aa, ab, ..., az, ba, ...
    first = chr(ord('a') + (index - 26) // 26)
    second = chr(ord('a') + (index - 26) % 26)
    return f"{first}{second}"


# ============================================================
# Main
# ============================================================

def main() -> None:
    # ---- 1. Parser les macros ----
    print("1. Parsing des macros...")
    macros: dict[str, dict] = {}
    for f in sorted(MACROS_DIR.glob('*.sql')):
        parsed = parse_macro_file(f)
        macros[parsed['name']] = parsed
    print(f"   {len(macros)} macros parsées")

    # ---- 2. Parser les modèles dept19 ----
    print("2. Parsing des modèles dept19...")
    models: dict[str, dict] = {}
    for f in sorted(MODELS_DEPT_DIR.rglob('*.sql')):
        name = f.stem
        content = f.read_text(encoding='utf-8', errors='replace')
        direct_refs = extract_all_refs(content)
        macro_calls = extract_macro_calls(content)

        # Refs transitives via macros
        all_refs = set(direct_refs)
        for mc in macro_calls:
            all_refs |= resolve_macro_refs(mc, macros)

        models[name] = {
            'path': f.relative_to(PROJECT_DIR),
            'refs': all_refs,
            'macro_calls': macro_calls,
            'is_cte': is_cte_model(name, f),
        }
    print(f"   {len(models)} modèles parsés")

    # ---- 3. Parser les seeds dept19 ----
    print("3. Parsing des seeds dept19...")
    seeds: dict[str, dict] = {}
    dept_seeds_dir = SEEDS_DIR / f'dept{DEPT}'
    if dept_seeds_dir.exists():
        for f in sorted(dept_seeds_dir.rglob('*.csv')):
            seeds[f.stem] = {'path': f.relative_to(PROJECT_DIR)}
    print(f"   {len(seeds)} seeds trouvés")

    # ---- 4. Construire le DAG (deps internes dept19 uniquement) ----
    print("4. Construction du DAG...")
    all_model_names = set(models.keys())
    dag: dict[str, list[str]] = {}
    for name, info in models.items():
        dag[name] = [r for r in info['refs'] if r in all_model_names and r != name]

    # ---- 5. BFS par niveaux (modèles non-CTE) ----
    print("5. Tri topologique par niveaux...")
    non_cte = {n for n in models if not models[n]['is_cte']}
    cte_set = {n for n in models if models[n]['is_cte']}

    # DAG effectif : les non-CTE « voient à travers » les CTE
    def resolve_through_cte(model: str, visited: set[str] | None = None) -> set[str]:
        if visited is None:
            visited = set()
        if model in visited:
            return set()
        visited.add(model)
        result: set[str] = set()
        for dep in dag.get(model, []):
            if dep in non_cte:
                result.add(dep)
            elif dep in cte_set:
                result |= resolve_through_cte(dep, visited)
        return result

    effective_dag: dict[str, set[str]] = {}
    for name in non_cte:
        effective_dag[name] = resolve_through_cte(name)

    # Kahn par niveaux
    remaining = {n: set(effective_dag.get(n, set())) for n in non_cte}
    assigned_level: dict[str, int] = {}
    level = 1
    while True:
        ready = sorted(n for n in remaining if not remaining[n])
        if not ready:
            break
        for n in ready:
            assigned_level[n] = level
        ready_set = set(ready)
        for n in ready:
            del remaining[n]
        for n in remaining:
            remaining[n] -= ready_set
        level += 1

    if remaining:
        print(f"   ATTENTION : {len(remaining)} modèle(s) non attribués (cycle ?) :")
        for n, deps in sorted(remaining.items()):
            print(f"     {n} → deps restantes : {deps}")
        # Attribuer un niveau élevé par défaut
        for n in remaining:
            assigned_level[n] = level

    # ---- 5b. Reclassement par dossier des modèles sans dépendance interne ----
    # Certains modèles n'ont aucune dépendance ref() vers un autre modèle dept19
    # (ils lisent uniquement des sources brutes). Le DAG les place au niveau 1,
    # mais leur dossier d'appartenance indique à quelle étape métier ils se
    # rattachent. On utilise le niveau médian des modèles co-localisés dans le
    # même dossier pour leur attribuer un niveau plus cohérent.
    MODELES_RECLASSES_PAR_DOSSIER: set[str] = set()

    level_1_models = [n for n, lvl in assigned_level.items() if lvl == 1]
    # creer_vue_19 est la vraie racine → on ne la reclasse pas
    reclassable = [n for n in level_1_models if n != 'creer_vue_' + DEPT]

    if reclassable:
        # Calculer le niveau médian par dossier (en excluant les reclassables)
        folder_levels: dict[str, list[int]] = defaultdict(list)
        for name, lvl in assigned_level.items():
            if name not in reclassable:
                folder = str(models[name]['path'].parent)
                folder_levels[folder].append(lvl)

        for name in reclassable:
            folder = str(models[name]['path'].parent)
            sibling_levels = folder_levels.get(folder, [])
            if sibling_levels:
                # Utiliser le minimum des niveaux du dossier (= première étape)
                inferred = min(sibling_levels)
            else:
                # Pas de voisin : remonter au dossier parent
                parent_folder = str(models[name]['path'].parent.parent)
                parent_levels = folder_levels.get(parent_folder, [])
                inferred = min(parent_levels) if parent_levels else 1

            if inferred != 1:
                assigned_level[name] = inferred
                MODELES_RECLASSES_PAR_DOSSIER.add(name)

        # Propager : si un modèle dépend d'un reclassé et que son niveau
        # est ≤ au nouveau niveau du reclassé, on le décale.
        if MODELES_RECLASSES_PAR_DOSSIER:
            # Construire les arêtes directes (parent → enfants)
            forward: dict[str, set[str]] = defaultdict(set)
            for child, parents in effective_dag.items():
                for p in parents:
                    forward[p].add(child)
            # BFS de propagation
            queue = deque(MODELES_RECLASSES_PAR_DOSSIER)
            while queue:
                src = queue.popleft()
                for child in forward.get(src, set()):
                    if assigned_level[child] <= assigned_level[src]:
                        assigned_level[child] = assigned_level[src] + 1
                        queue.append(child)

        if MODELES_RECLASSES_PAR_DOSSIER:
            print(f"   {len(MODELES_RECLASSES_PAR_DOSSIER)} modèle(s) reclassé(s) "
                  f"par dossier (sans dépendance DAG interne) :")
            for n in sorted(MODELES_RECLASSES_PAR_DOSSIER):
                folder = str(models[n]['path'].parent)
                print(f"     {n} → niveau {assigned_level[n]} (dossier: {folder})")

    # ---- 6. Préfixes des modèles non-CTE ----
    print("6. Attribution des préfixes mdl...")
    level_groups: dict[int, list[str]] = defaultdict(list)
    for name, lvl in assigned_level.items():
        level_groups[lvl].append(name)

    new_names: dict[str, str] = {}
    prefix_tags: dict[str, str] = {}  # model → mdlN[letter] (sans le _ ni le nom)
    for lvl in sorted(level_groups):
        # Tri par dossier parent puis par nom, pour regrouper les modèles
        # d'un même dossier avec des lettres consécutives.
        names = sorted(level_groups[lvl],
                       key=lambda n: (str(models[n]['path'].parent), n))
        if len(names) == 1:
            tag = f"mdl{lvl}"
            new_names[names[0]] = f"{tag}_{names[0]}"
            prefix_tags[names[0]] = tag
        else:
            for i, name in enumerate(names):
                suffix = to_letter_suffix(i)
                tag = f"mdl{lvl}{suffix}"
                new_names[name] = f"{tag}_{name}"
                prefix_tags[name] = tag

    # ---- 7. Préfixes des CTE ----
    print("7. Attribution des préfixes cte...")

    # Surcharges manuelles : CTE dont le parent ne peut pas être déduit du DAG
    # car la relation passe par une chaîne de macros invisible au ref().
    CTE_PARENT_OVERRIDE: dict[str, str] = {
        # lin_verif_historique_trafic est appelé via la macro
        # cte_verif_historique_trafic_lin → verifier_suspect_indic_lin
        # → lin_verif_histo_cptg_suspect_19 (niveau 13)
        'lin_verif_historique_trafic': 'lin_verif_histo_cptg_suspect_' + DEPT,
        # lin_cte_verif_coherence_cpt_std_lin_19__cpt_lin : sa macro fait
        # ref('lin_update_cpt_hors_dept_dans_na_19') (niv.13) et est consommée
        # par verifier_coherence_comptag_standardisation_vs_linearisation_lin
        # → lin_verif_coherence_cptg_stdardisation_vs_lin_19 (niveau 14)
        'lin_cte_verif_coherence_cpt_std_lin_' + DEPT + '__cpt_lin':
            'lin_verif_coherence_cptg_stdardisation_vs_lin_' + DEPT,
    }

    # Graphe inversé : qui dépend de qui ?
    reverse_dag: dict[str, set[str]] = defaultdict(set)
    for name, deps in dag.items():
        for dep in deps:
            reverse_dag[dep].add(name)

    def find_parent(cte: str, visited: set[str] | None = None) -> str | None:
        """Remonte le DAG inversé pour trouver le premier modèle non-CTE."""
        if visited is None:
            visited = set()
        if cte in visited:
            return None
        visited.add(cte)
        consumers = sorted(reverse_dag.get(cte, set()))
        # Priorité aux non-CTE directs
        for c in consumers:
            if c in non_cte:
                return c
        # Sinon remonter via d'autres CTE
        for c in consumers:
            if c in cte_set:
                result = find_parent(c, visited)
                if result:
                    return result
        return None

    def infer_parent_by_name(cte: str) -> str | None:
        """Infère le parent d'un CTE orphelin par similarité de nom ou proximité.

        Stratégies :
        1. Pattern lin_cte_XXX_19__YYY → chercher non-CTE contenant XXX
        2. Overlap de mots significatifs
        3. Proximité de répertoire (CTE dans cte/ → parent dans le dossier parent)
        """
        # --- Stratégie 1 : extraction du core ---
        m = re.match(r'^lin_cte_(.+?)__\w+$', cte)
        if m:
            core = m.group(1)
        else:
            core = cte

        # Match exact du core
        for nc in non_cte:
            nc_stripped = re.sub(r'^(mdl_lin_|mdl_|lin_)', '', nc)
            if core == nc_stripped or core in nc:
                return nc

        # --- Stratégie 2 : overlap de mots significatifs ---
        # Découper le core en mots (split par _), ignorer les tokens courts et dept
        core_words = {w for w in core.split('_')
                      if len(w) > 2 and w != DEPT}
        best_nc = None
        best_score = 0
        for nc in non_cte:
            nc_words = {w for w in nc.split('_')
                        if len(w) > 2 and w != DEPT}
            overlap = len(core_words & nc_words)
            if overlap > best_score:
                best_score = overlap
                best_nc = nc
        if best_score >= 2:
            return best_nc

        # --- Stratégie 3 : proximité de répertoire ---
        cte_path = models[cte]['path']
        cte_parent_dir = cte_path.parent.parent  # remonter au-dessus de cte/
        for nc in non_cte:
            nc_path = models[nc]['path']
            if str(nc_path).startswith(str(cte_parent_dir)):
                # Premier modèle "voisin" dans l'arborescence
                if best_nc is None:
                    best_nc = nc
        return best_nc

    cte_parent: dict[str, str | None] = {}
    for cte in cte_set:
        if cte in CTE_PARENT_OVERRIDE:
            parent = CTE_PARENT_OVERRIDE[cte]
        else:
            parent = find_parent(cte)
            if parent is None:
                parent = infer_parent_by_name(cte)
        cte_parent[cte] = parent

    # Grouper les CTE par parent
    parent_ctes: dict[str, list[str]] = defaultdict(list)
    orphan_ctes: list[str] = []
    for cte, parent in cte_parent.items():
        if parent:
            parent_ctes[parent].append(cte)
        else:
            orphan_ctes.append(cte)

    for parent, ctes in parent_ctes.items():
        tag = prefix_tags.get(parent, 'mdl0')
        for k, cte_name in enumerate(sorted(ctes), start=1):
            new_names[cte_name] = f"cte{k}_{tag}_{cte_name}"

    for cte in sorted(orphan_ctes):
        new_names[cte] = f"cte0_orphelin_{cte}"

    # ---- 8. Préfixes des seeds ----
    print("8. Attribution des préfixes sed...")
    seed_to_models: dict[str, list[str]] = defaultdict(list)
    for name, info in models.items():
        for r in info['refs']:
            if r in seeds:
                seed_to_models[r].append(name)

    seed_new_names: dict[str, str] = {}
    for seed_name in sorted(seeds):
        referencing = seed_to_models.get(seed_name, [])
        # Choisir le modèle référent avec le plus petit niveau
        best_model = None
        best_level = float('inf')
        for m in referencing:
            lvl = assigned_level.get(m, float('inf'))
            if lvl < best_level:
                best_level = lvl
                best_model = m
        if best_model and best_model in prefix_tags:
            num = prefix_tags[best_model].replace('mdl', '')
            seed_new_names[seed_name] = f"sed{num}_{seed_name}"
        else:
            seed_new_names[seed_name] = f"sed0_{seed_name}"

    # ---- 9. Génération du CSV ----
    print(f"9. Écriture de {OUTPUT_CSV.name}...")

    def nettoyer_nom(nouveau_nom: str) -> str:
        """Supprime les doublons de préfixe dans le nouveau nom.

        Règles :
        - mdlXX[y]_mdl_  → mdlXX[y]_       (supprime le 2e 'mdl_')
        - cteK_mdlXX[y]_lin_cte_  → cteK_mdlXX[y]_lin_   (supprime le 2e 'cte_')
        - sedXX[y]_dept19_  → sedXX[y]_dept19_  (pas de doublon)
        """
        # Pattern 1 : mdlXX[y]_ suivi de mdl_
        cleaned = re.sub(r'^(mdl\d+[a-z]?)_mdl_', r'\1_', nouveau_nom)
        # Pattern 2 : cteK_mdlXX[y]_ suivi de lin_cte_
        cleaned = re.sub(r'^(cte\d+_mdl\d+[a-z]?)_lin_cte_', r'\1_lin_', cleaned)
        return cleaned

    # Table d'abréviations : (mot_source, abréviation)
    # L'ordre compte : les remplacements les plus longs d'abord pour éviter
    # les remplacements partiels (ex: 'linearisation' avant 'linearise').
    ABBREVIATIONS: list[tuple[str, str]] = [
        ('stdardisation', 'std'),
        ('gestionnaires', 'gest'),
        ('statistiques', 'stats'),
        ('linearisation', 'linear'),
        ('millessime', 'mill'),
        ('limitrophe', 'limitr'),
        ('historique', 'histo'),
        ('estimation', 'estim'),
        ('linearise', 'linear'),
        ('horsagglo', 'h_agglo'),
        ('coherence', 'coher'),
        ('bretelles', 'bret'),
        ('lineaire', 'linear'),
        ('nouveau', 'nouv'),
        ('abertes', 'aberr'),
        ('comptag', 'cptg'),
        ('update', 'upd'),
        ('trafic', 'traf'),
        ('coment', 'cmt'),
        ('bdtopo', 'bdt'),
        ('section', 'sect'),
        ('verif', 'chk'),
        ('evol', 'evo'),
    ]

    def abreger_nom(nom_court: str) -> str:
        """Applique les abréviations sur un nom_court pour produire un nom abrégé."""
        result = nom_court
        for mot, abrev in ABBREVIATIONS:
            result = result.replace(mot, abrev)
        return result

    rows: list[dict] = []

    for name in sorted(models):
        is_cte = models[name]['is_cte']
        if is_cte:
            parent = cte_parent.get(name)
            lvl_display = f"cte(→{assigned_level.get(parent, '?')})" if parent else 'cte(?)'
        elif name in MODELES_RECLASSES_PAR_DOSSIER:
            lvl_display = f"{assigned_level[name]}*"
        else:
            lvl_display = str(assigned_level.get(name, '?'))
        nn = new_names.get(name, f'???_{name}')
        nc = nettoyer_nom(nn)
        rows.append({
            'type': 'model',
            'ancien_nom': name,
            'nouveau_nom': nn,
            'nom_court': nc,
            'nom_abrev': abreger_nom(nc),
            'niveau_dag': lvl_display,
            'chemin_fichier': str(models[name]['path']),
        })

    for name in sorted(seeds):
        snn = seed_new_names.get(name, f'sed0_{name}')
        snc = nettoyer_nom(snn)
        rows.append({
            'type': 'seed',
            'ancien_nom': name,
            'nouveau_nom': snn,
            'nom_court': snc,
            'nom_abrev': abreger_nom(snc),
            'niveau_dag': '',
            'chemin_fichier': str(seeds[name]['path']),
        })

    # Tri : d'abord par niveau (int), puis par nouveau nom ; seeds en fin
    def sort_key(row: dict) -> tuple:
        if row['type'] == 'model':
            lvl_str = row['niveau_dag']
            m = re.search(r'(\d+)', lvl_str)
            lvl_num = int(m.group(1)) if m else 999
            is_cte_row = lvl_str.startswith('cte')
            return (0, lvl_num, is_cte_row, row['nouveau_nom'])
        return (1, 0, False, row['nouveau_nom'])

    rows.sort(key=sort_key)

    with open(OUTPUT_CSV, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(
            f,
            fieldnames=['type', 'ancien_nom', 'nouveau_nom', 'nom_court', 'nom_abrev', 'niveau_dag', 'chemin_fichier'],
            delimiter=';',
        )
        writer.writeheader()
        writer.writerows(rows)

    nb_models = sum(1 for r in rows if r['type'] == 'model')
    nb_seeds = sum(1 for r in rows if r['type'] == 'seed')
    print(f"\n   Terminé ! {len(rows)} entrées écrites dans {OUTPUT_CSV.name}")
    print(f"   - {nb_models} modèles ({len(non_cte)} standard + {len(cte_set)} CTE)")
    print(f"   - {nb_seeds} seeds")

    # ---- 10. Vérifications ----
    print("\n10. Vérifications :")

    # Unicité (nouveau_nom, nom_court, nom_abrev)
    all_new = list(new_names.values()) + list(seed_new_names.values())
    all_short = [nettoyer_nom(n) for n in all_new]
    all_abrev = [abreger_nom(nettoyer_nom(n)) for n in all_new]
    if len(set(all_new)) == len(all_new):
        print("   OK  Tous les nouveaux noms sont uniques")
    else:
        seen: set[str] = set()
        dupes: list[str] = []
        for n in all_new:
            if n in seen:
                dupes.append(n)
            seen.add(n)
        print(f"   ERR {len(dupes)} doublon(s) détecté(s) : {dupes}")

    if len(set(all_short)) == len(all_short):
        print("   OK  Tous les noms courts sont uniques")
    else:
        seen2: set[str] = set()
        dupes2: list[str] = []
        for n in all_short:
            if n in seen2:
                dupes2.append(n)
            seen2.add(n)
        print(f"   ERR {len(dupes2)} doublon(s) noms courts : {dupes2}")

    if len(set(all_abrev)) == len(all_abrev):
        print("   OK  Tous les noms abrégés sont uniques")
    else:
        seen3: set[str] = set()
        dupes3: list[str] = []
        for n in all_abrev:
            if n in seen3:
                dupes3.append(n)
            seen3.add(n)
        print(f"   ERR {len(dupes3)} doublon(s) noms abrégés : {dupes3}")

    # Validité PostgreSQL (nouveau_nom, nom_court et nom_abrev)
    invalid = [n for n in set(all_new) if not re.match(r'^[a-z][a-z0-9_]*$', n)]
    invalid_short = [n for n in set(all_short) if not re.match(r'^[a-z][a-z0-9_]*$', n)]
    invalid_abrev = [n for n in set(all_abrev) if not re.match(r'^[a-z][a-z0-9_]*$', n)]
    if not invalid and not invalid_short and not invalid_abrev:
        print("   OK  Tous les noms sont des identifiants PostgreSQL valides")
    else:
        if invalid:
            print(f"   ERR {len(invalid)} identifiant(s) invalide(s) : {invalid}")
        if invalid_short:
            print(f"   ERR {len(invalid_short)} nom(s) court(s) invalide(s) : {invalid_short}")
        if invalid_abrev:
            print(f"   ERR {len(invalid_abrev)} nom(s) abrégé(s) invalide(s) : {invalid_abrev}")

    # Couverture
    missing_models = [n for n in models if n not in new_names]
    if not missing_models:
        print(f"   OK  Les {len(models)} modèles dept19 sont couverts")
    else:
        print(f"   ERR {len(missing_models)} modèle(s) non couvert(s) : {missing_models}")

    # Cohérence DAG
    incoherent = []
    for name, lvl in assigned_level.items():
        for dep in effective_dag.get(name, set()):
            dep_lvl = assigned_level.get(dep)
            if dep_lvl is not None and dep_lvl >= lvl:
                incoherent.append((name, lvl, dep, dep_lvl))
    if not incoherent:
        print("   OK  Cohérence DAG : chaque modèle dépend de niveaux inférieurs")
    else:
        print(f"   ERR {len(incoherent)} incohérence(s) DAG :")
        for n, nl, d, dl in incoherent:
            print(f"       {n} (niv.{nl}) dépend de {d} (niv.{dl})")

    # Résumé des niveaux
    print("\n   Résumé par niveau :")
    for lvl in sorted(level_groups):
        names = sorted(level_groups[lvl])
        label = ', '.join(names[:5])
        if len(names) > 5:
            label += f', ... (+{len(names) - 5})'
        print(f"   Niveau {lvl:>2} : {len(names):>2} modèle(s) — {label}")
    if cte_set:
        print(f"   CTE      : {len(cte_set):>2} modèle(s)")
    if orphan_ctes:
        print(f"   Orphelins: {len(orphan_ctes):>2} CTE sans parent — {', '.join(sorted(orphan_ctes))}")
    if MODELES_RECLASSES_PAR_DOSSIER:
        print(f"\n   (*) = niveau attribué par dossier d'appartenance, pas par le DAG")
        print(f"         ({len(MODELES_RECLASSES_PAR_DOSSIER)} modèle(s) sans dépendance ref() interne)")


if __name__ == '__main__':
    main()
