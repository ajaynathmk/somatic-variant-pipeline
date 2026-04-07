#!/bin/bash
# =============================================================================
# run_pipeline.sh — End-to-end Somatic Variant Calling
# =============================================================================

set -euo pipefail

# 1. This line is CRITICAL: It allows the script to use the 'micromamba' command
eval "$(micromamba shell hook --shell bash)"

SCRIPTS_DIR="$(dirname "$0")/scripts"

echo ">>> Starting Setup..."
bash "${SCRIPTS_DIR}/01_setup_environment.sh"

# 2. ACTIVATE the environment for the rest of this master script
micromamba activate somatic-variant-pipeline

echo ">>> Environment active. Running remaining steps..."

# 3. Execute modular steps
bash "${SCRIPTS_DIR}/02_quality_control.sh"
bash "${SCRIPTS_DIR}/03_alignment.sh"
bash "${SCRIPTS_DIR}/04_variant_calling.sh"
bash "${SCRIPTS_DIR}/05_annotation.sh"

echo ">>> Pipeline Complete!"