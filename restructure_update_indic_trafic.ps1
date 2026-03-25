# Script de restructuration update_indic_trafic
# Crée la structure 2 phases : commentaires_tmja_f / calculs_trafic

Write-Host "=== Restructuration update_indic_trafic ===" -ForegroundColor Cyan

$base = "models\dept19\lin\update_indic_trafic"
$seedBase = "seeds\dept19\lin"

# 1. Créer les dossiers s'ils n'existent pas
Write-Host "`n[1/4] Création structure de dossiers..." -ForegroundColor Yellow
$folders = @(
    "$base\commentaires_tmja_f"
    "$base\commentaires_tmja_f\verifs"
    "$base\calculs_trafic"
    "$base\calculs_trafic\verifs"
    "$seedBase\commentaires_tmja_f"
    "$seedBase\verifications"
)

foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "  Créé: $folder" -ForegroundColor Green
    } else {
        Write-Host "  Existe déjà: $folder" -ForegroundColor Gray
    }
}

# 2. Déplacer les 6 modèles vers commentaires_tmja_f
Write-Host "`n[2/4] Déplacement modèles vers commentaires_tmja_f..." -ForegroundColor Yellow
$modelesCommentaires = @(
    "lin_update_indic_trafic_19.sql"
    "lin_update_cpt_hors_dept_dans_na_19.sql"
    "lin_update_coment_tmj_f_lui_mm_19.sql"
    "lin_update_coment_tmj_f_ids_19.sql"
    "mdl_lin_update_coment_tmj_f_sens_19.sql"
    "mdl_lin_update_coment_tmj_f_sens_dbl_spl_19.sql"
)

foreach ($file in $modelesCommentaires) {
    $source = "$base\$file"
    $dest = "$base\commentaires_tmja_f\$file"
    
    if (Test-Path $source) {
        Move-Item -Path $source -Destination $dest -Force
        Write-Host "  Déplacé: $file" -ForegroundColor Green
    } elseif (Test-Path $dest) {
        Write-Host "  Déjà dans commentaires_tmja_f: $file" -ForegroundColor Gray
    } else {
        Write-Host "  ATTENTION: Fichier introuvable: $file" -ForegroundColor Red
    }
}

# 3. Déplacer les 5 modèles vers calculs_trafic
Write-Host "`n[3/4] Déplacement modèles vers calculs_trafic..." -ForegroundColor Yellow
$modelesCalculs = @(
    "mdl_lin_update_tmja_final_19.sql"
    "mdl_lin_update_veh_km_19.sql"
    "mdl_lin_update_pl_final_pl_km_19.sql"
    "mdl_lin_update_coment_cpt_19.sql"
    "mdl_lin_update_coment_tmj_f_estim_19.sql"
)

foreach ($file in $modelesCalculs) {
    $source = "$base\$file"
    $dest = "$base\calculs_trafic\$file"
    
    if (Test-Path $source) {
        Move-Item -Path $source -Destination $dest -Force
        Write-Host "  Déplacé: $file" -ForegroundColor Green
    } elseif (Test-Path $dest) {
        Write-Host "  Déjà dans calculs_trafic: $file" -ForegroundColor Gray
    } else {
        Write-Host "  ATTENTION: Fichier introuvable: $file" -ForegroundColor Red
    }
}

# 4. Déplacer les vérifications
Write-Host "`n[4/4] Déplacement vérifications..." -ForegroundColor Yellow

# Liste des 22 verifs pour commentaires_tmja_f
$verifsCommentaires = @(
    "lin_verif_ann_rrn_indispo_19.sql"
    "lin_verif_coherence_cptg_stdardisation_vs_lin_19.sql"
    "lin_verif_coment_tmj_f_val_19.sql"
    "lin_verif_histo_cptg_suspect_19.sql"
    "lin_verif_periode_19.sql"
    "lin_verif_stat_importc_nature_estimee_19.sql"
    "lin_verif_coment_tmj_f_reseau_ratio_19.sql"
    "lin_verif_coment_tmj_f_attr_modif_19.sql"
    "lin_verif_coment_tmj_f_before_updt_tmja_19.sql"
    "lin_verif_coment_tmj_f_recup_19.sql"
    "lin_verif_id_comptag_part1_post_coment_tmj_f_19.sql"
    "lin_verif_numero_rrn_19.sql"
    "lin_verif_vals_abertes_tmja_19.sql"
    "mdl_lin_verif_ann_cptgassoc_cptgref_19.sql"
    "mdl_lin_verif_comptag_sens_uniq_19.sql"
    "mdl_lin_verif_cptg_sens_uniq_occurc2_19.sql"
    "mdl_lin_verif_evol_cpt_dev_assoc_19.sql"
    "mdl_lin_verif_recup_agglo_19.sql"
    "mdl_lin_verif_sens_agglo_19.sql"
    "mdl_lin_verif_sens_bretelles_rrn_19.sql"
    "mdl_lin_verif_sens_coment_tmj_f_horsagglo_19.sql"
    "mdl_lin_verif_sens_troncon_prch_cptg_19.sql"
)

foreach ($file in $verifsCommentaires) {
    $source = "$base\verifs\$file"
    $dest = "$base\commentaires_tmja_f\verifs\$file"
    
    if (Test-Path $source) {
        Move-Item -Path $source -Destination $dest -Force
        Write-Host "  Déplacé verif: $file" -ForegroundColor Green
    } elseif (Test-Path $dest) {
        Write-Host "  Verif déjà déplacée: $file" -ForegroundColor Gray
    } else {
        Write-Host "  ATTENTION: Verif introuvable: $file" -ForegroundColor Red
    }
}

# Liste des 9 verifs pour calculs_trafic
$verifsCalculs = @(
    "lin_verif_stat_nbpt_gestionnaires_19.sql"
    "lin_verif_stat_nbpt_gestionnaires_annees_19.sql"
    "lin_verif_stat_nbpt_lgkm_annee_19.sql"
    "mdl_lin_statistiques_linearisation_19.sql"
    "mdl_lin_verif_id_comptag_millessime_en_cours_19.sql"
    "mdl_lin_verif_indic_agrege_after_update_19.sql"
    "mdl_lin_verif_pc_pl_after_update_final_19.sql"
    "mdl_lin_verif_pc_pl_after_update_group_gest_19.sql"
    "mdl_lin_verif_recup_linear_19.sql"
)

foreach ($file in $verifsCalculs) {
    $source = "$base\verifs\$file"
    $dest = "$base\calculs_trafic\verifs\$file"
    
    if (Test-Path $source) {
        Move-Item -Path $source -Destination $dest -Force
        Write-Host "  Déplacé verif: $file" -ForegroundColor Green
    } elseif (Test-Path $dest) {
        Write-Host "  Verif déjà déplacée: $file" -ForegroundColor Gray
    } else {
        Write-Host "  ATTENTION: Verif introuvable: $file" -ForegroundColor Red
    }
}

# Vérifier si le dossier verifs est vide pour le supprimer
if ((Get-ChildItem "$base\verifs" | Measure-Object).Count -eq 0) {
    Remove-Item "$base\verifs" -Force
    Write-Host "  Dossier verifs/ vide supprimé" -ForegroundColor Green
}

# 5. Déplacer les seeds
Write-Host "`n[5/5] Déplacement seeds..." -ForegroundColor Yellow

$seedsCommentaires = @(
    "dept19_update_cpt_existant_mano.csv"
    "dept19_update_coment_tmj_f_sens.csv"
    "dept19_update_coment_tmj_f_with_coment_tmj_f.csv"
    "dept19_update_coment_tmj_f_with_ids.csv"
)

foreach ($file in $seedsCommentaires) {
    $source = "$seedBase\indic_trafic\$file"
    $dest = "$seedBase\commentaires_tmja_f\$file"
    
    if (Test-Path $source) {
        Move-Item -Path $source -Destination $dest -Force
        Write-Host "  Déplacé seed: $file" -ForegroundColor Green
    } elseif (Test-Path $dest) {
        Write-Host "  Seed déjà déplacé: $file" -ForegroundColor Gray
    } else {
        Write-Host "  ATTENTION: Seed introuvable: $file" -ForegroundColor Red
    }
}

# Déplacer le seed de vérification
$seedVerif = "dept19_verif_indic_trafic_qualite.csv"
$sourceVerif = "$seedBase\indic_trafic\$seedVerif"
$destVerif = "$seedBase\verifications\$seedVerif"

if (Test-Path $sourceVerif) {
    Move-Item -Path $sourceVerif -Destination $destVerif -Force
    Write-Host "  Déplacé seed verif: $seedVerif" -ForegroundColor Green
} elseif (Test-Path $destVerif) {
    Write-Host "  Seed verif déjà déplacé: $seedVerif" -ForegroundColor Gray
} else {
    Write-Host "  ATTENTION: Seed verif introuvable: $seedVerif" -ForegroundColor Red
}

Write-Host "`n=== Restructuration des fichiers terminée ===" -ForegroundColor Cyan
Write-Host "`nProchain: Redistribuer la documentation et mettre à jour dbt_project.yml" -ForegroundColor Yellow
