#!/bin/bash
# =============================================================================
# run_pipeline.sh — Execute all steps end-to-end
# Usage: bash run_pipeline.sh
# =============================================================================

set -euo pipefail

SCRIPTS_DIR="$(dirname "$0")/scripts"

echo "======================================================"
echo " Somatic Variant Calling Pipeline"
echo "======================================================"

bash "${SCRIPTS_DIR}/01_setup_environment.sh"
bash "${SCRIPTS_DIR}/02_quality_control.sh"
bash "${SCRIPTS_DIR}/03_alignment.sh"
bash "${SCRIPTS_DIR}/04_variant_calling.sh"
bash "${SCRIPTS_DIR}/05_annotation.sh"

echo ""
echo "======================================================"
echo " Pipeline complete. Final output: results/annotated_somatic.vcf"
echo "======================================================"
