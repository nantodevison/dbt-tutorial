"""Module d'exécution des commandes dbt pour la linéarisation.

Usage en import :
    from dbt_runner import create_vue_dept, run_pipeline
    create_vue_dept('all')
    run_pipeline('all')

Usage en CLI :
    python dbt_runner.py all                   # pipeline complet
    python dbt_runner.py all --dept 24         # pipeline pour le dept 24
    python dbt_runner.py create_vue_dept run   # une seule étape
"""

import subprocess
import sys
from pathlib import Path

import yaml

PROJECT_DIR = Path(__file__).parent
DBT_PROJECT_PATH = PROJECT_DIR / 'dbt_project.yml'


def _load_dept() -> str:
    with open(DBT_PROJECT_PATH, encoding='utf-8') as f:
        config = yaml.safe_load(f)
    return str(config['vars']['dept'])


DEPT = _load_dept()


# ---------------------------------------------------------------------------
#  Fonctions de base
# ---------------------------------------------------------------------------

def _dbt_cmd(command: str, select: str, exclude: str | None = None) -> int:
    """Exécute une commande dbt et retourne le code de retour."""
    cmd = ['dbt', command, '--select', select]
    if exclude:
        cmd.extend(['--exclude', exclude])
    print(f"\n{'=' * 60}")
    print(f">>> {' '.join(cmd)}")
    print('=' * 60)
    result = subprocess.run(cmd, cwd=str(PROJECT_DIR))
    if result.returncode != 0:
        print(f"\nERREUR : commande échouée (code {result.returncode})")
    return result.returncode


def dbt_run(select: str) -> int:
    return _dbt_cmd('run', select)


def dbt_test(select: str, exclude: str | None = None) -> int:
    return _dbt_cmd('test', select, exclude)


def dbt_seed(select: str) -> int:
    return _dbt_cmd('seed', select)


def _run_steps(action: str, steps: list[tuple[str, list]]) -> int:
    """Exécute les étapes filtrées par action.

    Chaque étape est un tuple (type_cmd, [args_pour_la_fonction_de_base]).
    type_cmd est 'run', 'test' ou 'seed'.
    Retourne 0 si tout OK, sinon le premier code d'erreur.
    """
    for step_type, args in steps:
        if action != 'all' and step_type != action:
            continue
        if step_type == 'run':
            rc = dbt_run(*args)
        elif step_type == 'test':
            rc = dbt_test(*args)
        elif step_type == 'seed':
            rc = dbt_seed(*args)
        else:
            raise ValueError(f"Type de commande inconnu : {step_type}")
        if rc != 0:
            return rc
    return 0


# ---------------------------------------------------------------------------
#  Fonctions métier
# ---------------------------------------------------------------------------

def apply_ad_supr_row_mill(action: str = 'all', dept: str = DEPT) -> int:
    """1. Seed + test ad_suppr_row, puis run + test mdl_ad_troncons."""
    seed = 'ad_suppr_row_new_millesime'
    model = 'mdl_ad_troncons_new_millesime'
    return _run_steps(action, [
        ('seed', [seed]),
        ('test', [seed]),
        ('run',  [model]),
        ('test', [model]),
    ])


def create_vue_dept(action: str = 'all', dept: str = DEPT) -> int:
    """2. Créer la vue départementale."""
    model = f'mdl1_creer_vue_{dept}'
    return _run_steps(action, [
        ('run',  [model]),
        ('test', [model, 'test_name:equal_rowcount']),
    ])


def before_update_affectation_mano(action: str = 'all', dept: str = DEPT) -> int:
    """3. Vérifications avant affectation manuelle."""
    folder = f'models/dept{dept}/lin/before_update_affectation_mano'
    return _run_steps(action, [
        ('run',  [folder]),
        ('test', [folder]),
    ])


def seed_affectation_pt_mano(action: str = 'all', dept: str = DEPT) -> int:
    """4. Seeds des points d'affectation manuelle."""
    folder = f'seeds/dept{dept}/lin/affectation_pt_mano'
    return _run_steps(action, [
        ('seed', [folder]),
        ('test', [folder, f'mdl7_lin_upd_nouv_point_{dept}']),
    ])


def update_affectation_mano(action: str = 'all', dept: str = DEPT) -> int:
    """5. Mise à jour de l'affectation manuelle."""
    folder = f'models/dept{dept}/lin/update_affectation_mano'
    return _run_steps(action, [
        ('run',  [folder]),
        ('test', [folder]),
    ])


def check_update_affectation_mano(action: str = 'all', dept: str = DEPT) -> int:
    """6. Vérifications post affectation manuelle."""
    folder = f'models/dept{dept}/lin/post_update_affectation_mano'
    return _run_steps(action, [
        ('run',  [folder]),
        ('test', [folder]),
    ])


def update_coment_tmj_f(action: str = 'all', dept: str = DEPT) -> int:
    """7. Seeds commentaires + run/test modèles commentaires tmja_f."""
    folder_seed = f'seeds/dept{dept}/lin/commentaires_tmja_f'
    folder_model = f'models/dept{dept}/lin/update_indic_trafic/commentaires_tmja_f'
    return _run_steps(action, [
        ('seed', [folder_seed]),
        ('run',  [folder_model]),
        ('test', [folder_seed]),
        ('test', [folder_model]),
    ])


def update_calculs_trafic(action: str = 'all', dept: str = DEPT) -> int:
    """8. Calculs de trafic."""
    folder = f'models/dept{dept}/lin/update_indic_trafic/calculs_trafic'
    return _run_steps(action, [
        ('run',  [folder]),
        ('test', [folder]),
    ])


def resume_linearisation(action: str = 'all', dept: str = DEPT) -> int:
    """9. Vue résumé de la linéarisation."""
    model = f'mdl23a_creer_vue_linear_{dept}'
    return _run_steps(action, [
        ('run', [model]),
    ])


# ---------------------------------------------------------------------------
#  Pipeline complet
# ---------------------------------------------------------------------------

PIPELINE = [
    ('apply_ad_supr_row_mill',        apply_ad_supr_row_mill),
    ('create_vue_dept',               create_vue_dept),
    ('before_update_affectation_mano', before_update_affectation_mano),
    ('seed_affectation_pt_mano',      seed_affectation_pt_mano),
    ('update_affectation_mano',       update_affectation_mano),
    ('check_update_affectation_mano', check_update_affectation_mano),
    ('update_coment_tmj_f',           update_coment_tmj_f),
    ('update_calculs_trafic',         update_calculs_trafic),
    ('resume_linearisation',          resume_linearisation),
]


def run_pipeline(action: str = 'all', dept: str = DEPT) -> int:
    """Enchaîne les 9 fonctions dans l'ordre. S'arrête à la première erreur."""
    print(f"\n{'#' * 60}")
    print(f"# PIPELINE COMPLET  (action={action}, dept={dept})")
    print(f"{'#' * 60}")
    for name, func in PIPELINE:
        print(f"\n{'─' * 60}")
        print(f"  ÉTAPE : {name}")
        print(f"{'─' * 60}")
        rc = func(action=action, dept=dept)
        if rc != 0:
            print(f"\n✗ Pipeline interrompu à l'étape '{name}' (code {rc})")
            return rc
        print(f"\n✓ {name} OK")
    print(f"\n{'#' * 60}")
    print("# PIPELINE TERMINÉ AVEC SUCCÈS")
    print(f"{'#' * 60}")
    return 0


# ---------------------------------------------------------------------------
#  CLI
# ---------------------------------------------------------------------------

FUNCTIONS = {name: func for name, func in PIPELINE}
FUNCTIONS['run_pipeline'] = run_pipeline


def main():
    """Point d'entrée CLI.

    Usage :
        python dbt_runner.py <fonction> <action> [--dept XX]
        python dbt_runner.py all                  # = run_pipeline('all')
        python dbt_runner.py create_vue_dept test --dept 24
    """
    args = sys.argv[1:]
    if not args:
        print("Usage : python dbt_runner.py <fonction|all> <action> [--dept XX]")
        print(f"\nFonctions : {', '.join(FUNCTIONS.keys())}")
        print("Actions   : run, test, seed, all")
        sys.exit(1)

    # Extraire --dept si présent
    dept = DEPT
    if '--dept' in args:
        idx = args.index('--dept')
        dept = args[idx + 1]
        args = args[:idx] + args[idx + 2:]

    func_name = args[0]
    action = args[1] if len(args) > 1 else 'all'

    if action not in ('run', 'test', 'seed', 'all'):
        print(f"Action invalide : '{action}'. Valeurs possibles : run, test, seed, all")
        sys.exit(1)

    # Raccourci : "python dbt_runner.py all" → run_pipeline
    if func_name == 'all':
        sys.exit(run_pipeline(action=action, dept=dept))

    if func_name not in FUNCTIONS:
        print(f"Fonction inconnue : '{func_name}'")
        print(f"Fonctions disponibles : {', '.join(FUNCTIONS.keys())}")
        sys.exit(1)

    sys.exit(FUNCTIONS[func_name](action=action, dept=dept))


if __name__ == '__main__':
    main()
