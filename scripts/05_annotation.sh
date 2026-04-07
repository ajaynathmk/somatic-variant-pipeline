#!/bin/bash
# =============================================================================
# Script 5: Variant Annotation with Ensembl VEP
# =============================================================================

set -euo pipefail

eval "$(micromamba shell hook --shell bash)"
micromamba activate somatic-variant-pipeline

echo ">>> Annotating filtered variants with VEP..."
vep \
    -i results/filtered_somatic.vcf.gz \
    -o results/annotated_somatic.vcf \
    --cache \
    --dir_cache ./vep_cache \
    --assembly GRCh38 \
    --offline \
    --fasta ref/ref_slice.fa \
    --everything \
    --vcf

echo ">>> Annotation complete. Output: results/annotated_somatic.vcf"
