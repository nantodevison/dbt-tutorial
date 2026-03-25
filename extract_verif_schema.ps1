# Script pour extraire les 9 modeles de verification depuis le .bak
$bakFile = "models\dept19\lin\update_indic_trafic\verifs\schema_lin_verif_indic_trafic.yml.bak"
$outFile = "models\dept19\lin\update_indic_trafic\calculs_trafic\verifs\schema_verif_calcul_trafic.yml"

# Lire tout le fichier
$lines = Get-Content $bakFile

# Header
$content = "version: 2`n`nmodels:`n"

# Extraire les 9 sections (lignes array 0-based, donc -1 des numéros grep)
# Section 1: lin_verif_stat_nbpt_lgkm_annee_19 (lignes 20 à 56)
$content += ($lines[20..55] -join "`n") + "`n`n"

# Section 2: lin_verif_stat_nbpt_gestionnaires_19 (lignes 56 à 79)
$content += ($lines[56..78] -join "`n") + "`n`n"

# Section 3: lin_verif_stat_nbpt_gestionnaires_annees_19 (lignes 79 à 102)
$content += ($lines[79..101] -join "`n") + "`n`n"

# Section 4: mdl_lin_verif_recup_linear_19 (lignes 811 à 832)  
$content += ($lines[811..831] -join "`n") + "`n`n"

# Section 5: mdl_lin_verif_id_comptag_millessime_en_cours_19 (lignes 832 à 849)
$content += ($lines[832..848] -join "`n") + "`n`n"

# Section 6: mdl_lin_verif_pc_pl_after_update_final_19 (lignes 866 à 883)
$content += ($lines[866..882] -join "`n") + "`n`n"

# Section 7: mdl_lin_verif_pc_pl_after_update_group_gest_19 (lignes 883 à 899)
$content += ($lines[883..898] -join "`n") + "`n`n"

# Section 8: mdl_lin_verif_indic_agrege_after_update_19 (lignes 899 à 954)
$content += ($lines[899..953] -join "`n") + "`n`n"

# Section 9: mdl_lin_statistiques_linearisation_19 (lignes 954 à 983 - fin)
$content += ($lines[954..983] -join "`n") + "`n"

# Renommer l'ancien fichier si existe
if (Test-Path $outFile) {
    Move-Item $outFile "$outFile.bad" -Force
    Write-Host "✓ Ancien fichier renommé en .bad" -ForegroundColor Yellow
}

# Écrire le nouveau fichier
$content | Set-Content $outFile -Encoding UTF8

Write-Host "✓ schema_verif_calcul_trafic.yml recréé avec 9 modèles" -ForegroundColor Green
